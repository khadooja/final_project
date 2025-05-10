import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/BaseRemoteDataSource.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/child_guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';

class ChildGuardianRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ChildGuardianRemoteDataSource {
  final ApiServiceManual _apiService;

  ChildGuardianRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResult<void>> linkGuardianToChild(
      String guardianId, String childId, String relationshipTypeId) async {
    try {
      await _apiService.linkGuardianToChild(
          guardianId, childId, relationshipTypeId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e.toString()));
    }
  }

  @override
  Future<ApiResult<List<RelationshipTypeModel>>> getRelationshipTypes() async {
    try {
      final response = await _apiService.getRelationshipTypes();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e.toString()));
    }
  }
}
