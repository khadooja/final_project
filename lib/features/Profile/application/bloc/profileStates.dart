import 'package:new_project/features/Profile/domain/entities/profile.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final UserProfile profile;

  ProfileLoadedState(this.profile);
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

class ProfileUpdatedState extends ProfileState {
  final UserProfile profile;

  ProfileUpdatedState(this.profile);
}
