import 'package:dio/dio.dart';
import 'package:new_project/features/Profile/data/datasources/datasources.dart';
import 'package:new_project/features/Profile/data/model/profile_model.dart';

class ProfileDataSourceImpl implements ProfileDataSource {
  final Dio dio;

  ProfileDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final response = await dio.get('/profile/$userId');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  @override
  Future<bool> updateProfile(UserProfile_model profile) async {
    try {
      final response = await dio.post("/updateProfile", data: profile.toJson());
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      final response = await dio.post('/updatePassword', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }
}
