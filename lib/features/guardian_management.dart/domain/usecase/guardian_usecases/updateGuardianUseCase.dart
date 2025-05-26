import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';

class UpdateGuardianUseCase {
  final ChildGuardianRepository repository;

  UpdateGuardianUseCase({required this.repository});

  Future<ApiResult<GurdianModel>> execute(
      String guardianId, GurdianModel guardianModel) async {
    return await repository.updateGuardian(guardianId, guardianModel);
  }
}
