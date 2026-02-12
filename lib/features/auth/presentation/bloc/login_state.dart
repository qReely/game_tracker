abstract class LoginState {}

/// User opened the app
class LoginInitial extends LoginState {}
/// User pressed the login button and waiting for response
class LoginLoading extends LoginState {}
/// User successfully logged in
class LoginSuccess extends LoginState {}
/// User failed to log in
class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}