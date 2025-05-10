import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';

abstract class ChildGuardianRepository {
  Future<ApiResult<void>> linkGuardianToChild(
      String guardianId, String childId, String relationshipTypeId);
  Future<ApiResult<List<RelationshipTypeModel>>> getRelationshipTypes();
}
