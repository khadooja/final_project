import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/child_guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relation_model.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';

class ChildGuardianRepositoryImpl implements ChildGuardianRepository {
  final ChildGuardianRemoteDataSource _dataSource; 
  ChildGuardianRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<GurdianModel>> addGuardian(GurdianModel model) {
    return _dataSource.addGuardian(model);
  }

  @override
  Future<ApiResult<GurdianModel>> updateGuardian(
      String id, GurdianModel model) {
    return _dataSource.updateGuardian(id, model);
  }

  @override
  Future<ApiResult<List<RelationModel>>> getRelationshipTypes() {
    return _dataSource.getRelationshipTypes();
  }
  

}
