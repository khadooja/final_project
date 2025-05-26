import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relation_model.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';

class GetRelationshipTypesUseCase {
  final ChildGuardianRepository repo;
  GetRelationshipTypesUseCase(this.repo);

  Future<ApiResult<List<RelationModel>>> call() {
    return repo.getRelationshipTypes();
  }
}
