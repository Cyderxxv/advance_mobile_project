import 'package:chatbot_ai/features/auth/data/input_login_model.dart';
import 'package:chatbot_ai/features/auth/data/input_register_model.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class EventRegister extends AuthEvent {
  final InputRegisterModel data;

  const EventRegister({required this.data});
}

final class EventLogin extends AuthEvent {
  final InputLoginModel data;

  const EventLogin({required this.data});
}

final class EventLogout extends AuthEvent {
  const EventLogout();
}