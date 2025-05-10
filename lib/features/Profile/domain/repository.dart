import 'package:new_project/features/Profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile(String userId);
  Future<bool> updatePassword(String oldPassword, String newPassword);
  Future<bool> updateProfile(UserProfile profile);
}
