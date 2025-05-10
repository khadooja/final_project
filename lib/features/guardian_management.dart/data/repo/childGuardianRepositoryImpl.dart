import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/child_guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';

class ChildGuardianRepositoryImpl implements ChildGuardianRepository {
  final ChildGuardianRemoteDataSource _dataSource; // تم التصحيح هنا
  ChildGuardianRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<void>> linkGuardianToChild(
      String guardianId, String childId, String relationshipTypeId) {
    return _dataSource.linkGuardianToChild(
        guardianId, childId, relationshipTypeId);
  }

  @override
  Future<ApiResult<List<RelationshipTypeModel>>> getRelationshipTypes() {
    return _dataSource.getRelationshipTypes();
  }
}
