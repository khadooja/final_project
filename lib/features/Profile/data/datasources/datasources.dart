import 'package:new_project/features/Profile/data/model/profile_model.dart';

abstract class ProfileDataSource {
  Future<Map<String, dynamic>> getProfile(String userId);
  Future<bool> updatePassword(String oldPassword, String newPassword);
  Future<bool> updateProfile(UserProfile_model profile);
}
