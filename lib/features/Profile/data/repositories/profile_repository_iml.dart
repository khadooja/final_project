import 'package:new_project/features/Profile/data/model/profile_model.dart';
import 'package:new_project/features/Profile/data/repositories/apiclient.dart';
import 'package:new_project/features/Profile/domain/entities/profile.dart';
import 'package:new_project/features/Profile/domain/repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryImpl({required this.apiClient});

  @override
  Future<UserProfile> getProfile(String userId) async {
    try {
      final response = await apiClient.get('/profile/$userId');
      if (response.statusCode == 200) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          return UserProfile_model.fromJson(response.data).toEntity();
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception(
            'Failed to load profile, status code: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading profile: $e');
      rethrow;
    }
  }

  @override
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      final response = await apiClient.post('/updatePassword', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200) {
        if (response.data != null && response.data['success'] == true) {
          return true;
        } else {
          throw Exception(
              'Password update failed: ${response.data['message']}');
        }
      } else {
        throw Exception(
            'Failed to update password, status code: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error updating password: $e');
      return false;
    }
  }

  @override
  Future<bool> updateProfile(UserProfile profile) async {
    try {
      final response = await apiClient.post(
        '/updateProfile',
        data: UserProfile_model.fromEntity(profile).toJson(),
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['success'] == true) {
          return true;
        } else {
          throw Exception('Profile update failed: ${response.data['message']}');
        }
      } else {
        throw Exception(
            'Failed to update profile, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}
