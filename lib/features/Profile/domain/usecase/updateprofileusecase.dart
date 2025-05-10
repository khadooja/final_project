import 'package:new_project/features/Profile/domain/entities/profile.dart';
import 'package:new_project/features/Profile/domain/repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<bool> execute(UserProfile profile) {
    return repository.updateProfile(profile);
  }
}
