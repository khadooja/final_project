import 'package:new_project/features/Profile/domain/repository.dart';

class UpdatePasswordUseCase {
  final ProfileRepository profileRepository;

  UpdatePasswordUseCase({required this.profileRepository});

  Future<bool> execute(String oldPassword, String newPassword) {
    return profileRepository.updatePassword(oldPassword, newPassword);
  }
}
