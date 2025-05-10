import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';

class LinkGuardianToChildUseCase {
  final ChildGuardianRepository repo;
  LinkGuardianToChildUseCase(this.repo);

  Future<ApiResult<void>> call(
      String guardianId, String childId, String relationshipTypeId) {
    return repo.linkGuardianToChild(guardianId, childId, relationshipTypeId);
  }
}
