abstract class LoginEvent {}

class GoogleSignInRequested extends LoginEvent {}

class LogoutRequested extends LoginEvent {}
class AnonymousSignInRequested extends LoginEvent {}