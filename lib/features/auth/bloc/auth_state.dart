import '../data/user_model.dart';

class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class StateRegister extends AuthState {
  final bool success;
  final String? message;
  final UserModel? userModel;

  const StateRegister({
    required this.success, 
    required this.message,
    this.userModel,
  });
}

class StateLogin extends AuthState {
  final bool success;
  final String? message;
  final UserModel? userModel;

  const StateLogin({
    required this.success,
    required this.message,
    this.userModel,
  }); 
}

class StateLogout extends AuthState {
  final bool success;
  final String? message;

  const StateLogout({
    required this.success,
    required this.message,
  });
}