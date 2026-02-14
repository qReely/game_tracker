import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      // If the state is loading, do nothing
      if (state is LoginLoading) return;

      // User pressed the login button
      // Emit a loading state
      emit(LoginLoading());
      try {
        await _authRepository.signInWithGoogle();
        emit(LoginSuccess());
      } on AuthFailure catch (e) {
        emit(LoginFailure(e.message));
      }
    });

    on<AnonymousSignInRequested>((event, emit) async {
      if (state is LoginLoading) return;
      emit(LoginLoading());
      try {
        await _authRepository.signInAnonymously();
        emit(LoginSuccess());
      } on AuthFailure catch (e) {
        emit(LoginFailure(e.message));
      }
    });
  }
}