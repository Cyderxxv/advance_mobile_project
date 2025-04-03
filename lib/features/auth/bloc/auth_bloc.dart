import 'dart:async';
import 'package:chatbot_ai/cores/store/store.dart';
import 'package:chatbot_ai/features/auth/bloc/auth_event.dart';
import 'package:chatbot_ai/features/auth/bloc/auth_state.dart';
import 'package:chatbot_ai/features/auth/data/user_model.dart';
import 'package:chatbot_ai/features/auth/domain/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<EventRegister>(_onEventRegister);
    on<EventLogin>(_onEventLogin);
    on<EventLogout>(_onEventLogout);
  }

  FutureOr<void> _onEventRegister(
      EventRegister event, Emitter<AuthState> emit) async {
    try {
      final response = await AuthRepo.instant.signUp(data: event.data);

      if (response == null) {
        emit(const StateRegister(success: false, message: 'Failed to connect to server'));
        return;
      }

      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(response.data);
        emit(StateRegister(
          success: true, 
          message: 'Registration successful',
          userModel: userModel,
        ));
      } else {
        final error = response.data['errors'];

        if (error != null && error is List && error.isNotEmpty) {
          emit(StateRegister(success: false, message: error.first));
        } else {
          emit(StateRegister(success: false, message: response.data['message'] ?? 'Registration failed'));
        }
      }
    } catch (e) {
      emit(StateRegister(success: false, message: e.toString()));
    }
  }

  FutureOr<void> _onEventLogin(EventLogin event, Emitter<AuthState> emit) async {
    try {
      final response = await AuthRepo.instant.signIn(data: event.data);
      
      if (response == null) {
        emit(const StateLogin(success: false, message: 'Failed to connect to server'));
        return;
      }

      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(response.data);
        await StoreData.instant.setToken(userModel.accessToken);
        await StoreData.instant.setRefreshToken(userModel.refreshToken);
        emit(StateLogin(
          success: true,
          message: 'Login successful',
          userModel: userModel,
        ));
      } else {
        final error = response.data['errors'];

        if (error != null && error is List && error.isNotEmpty) {
          emit(StateLogin(success: false, message: error.first));
        } else {
          emit(StateLogin(success: false, message: response.data['message'] ?? 'Login failed'));
        }
      }
    } catch (e) {
      emit(StateLogin(success: false, message: e.toString()));
    }
  }

  FutureOr<void> _onEventLogout(EventLogout event, Emitter<AuthState> emit) async {
    try {
      final response = await AuthRepo.instant.logout();
      if (response == null) {
        emit(const StateLogout(success: false, message: 'Failed to connect to server'));
        return;
      }

      if (response.statusCode == 200) {
        StoreData.instant.removeAllCache();
        emit(const StateLogout(success: true, message: 'Logout successful'));
      } else {
        emit(StateLogout(success: false, message: response.data['message'] ?? 'Logout failed'));
      }
    } catch (e) {
      emit(StateLogout(success: false, message: e.toString()));
    }
  }
}
