import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relation_model.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';

abstract class ChildGuardianRemoteDataSource extends PersonRemoteDataSource {
    Future<ApiResult<GurdianModel>> addGuardian(GurdianModel guardianModelModel);
  Future<ApiResult<GurdianModel>> updateGuardian(
      String guardianModelId, GurdianModel guardianModelModel);
  Future<ApiResult<List<RelationModel>>> getRelationshipTypes();
}
