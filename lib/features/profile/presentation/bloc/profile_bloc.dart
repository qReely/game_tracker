import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final LibraryRepository _libraryRepository;

  ProfileBloc(this._authRepository, this._libraryRepository) : super(ProfileInitial()) {
    on<LinkGoogleAccount>((event, emit) async {
      emit(ProfileLoading());
      try {
        await _authRepository.linkGoogleAccount();
        // After successful link, sync local data to remote
        await _libraryRepository.syncLocalToRemote();
        emit(ProfileLinkSuccess());
      } on AuthFailure catch (e) {
        emit(ProfileLinkFailure(e.message));
      } catch (e) {
        emit(ProfileLinkFailure("An unexpected error occurred"));
      }
    });

    on<SignOutRequested>((event, emit) async {
      await _authRepository.signOut();
      emit(ProfileSignOutSuccess());
    });
  }
}
