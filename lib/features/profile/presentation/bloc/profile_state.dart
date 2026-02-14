abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLinkSuccess extends ProfileState {}

class ProfileLinkFailure extends ProfileState {
  final String message;
  ProfileLinkFailure(this.message);
}

class ProfileSignOutSuccess extends ProfileState {}
