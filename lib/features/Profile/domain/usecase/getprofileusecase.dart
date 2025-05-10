import 'package:new_project/features/Profile/domain/entities/profile.dart';
import 'package:new_project/features/Profile/domain/repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase({required this.repository});

  Future<UserProfile> execute(String userId) async {
    return await repository.getProfile(userId);
  }
}
