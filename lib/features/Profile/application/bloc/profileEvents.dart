import 'package:new_project/features/Profile/domain/entities/profile.dart';

abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdatePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordEvent(this.oldPassword, this.newPassword);
}

class UpdateProfileEvent extends ProfileEvent {
  final UserProfile profile;

  UpdateProfileEvent(this.profile);
}
