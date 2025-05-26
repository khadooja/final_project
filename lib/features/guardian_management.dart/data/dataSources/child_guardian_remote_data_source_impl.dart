import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/child_guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relation_model.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

class ChildGuardianRemoteDataSourceImpl extends PersonRemoteDataSourceImpl
    implements ChildGuardianRemoteDataSource {
  final ApiServiceManual _apiService;

  ChildGuardianRemoteDataSourceImpl(this._apiService) : super(_apiService);

  @override
  Future<ApiResult<List<RelationModel>>> getRelationshipTypes() async {
    print("Fetching relationship types from remote data source");
    try {
      final response = await _apiService.getRelationshipTypes();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e.toString()));
    }
  }

  @override
  Future<ApiResult<GurdianModel>> addGuardian(GurdianModel guardianModel) {
    return callApi(() async {
      return await _apiService.addGuardian(guardianModel);
    });
  }

  @override
  Future<ApiResult<GurdianModel>> updateGuardian(
      String id, GurdianModel model) {
    return callApi(() async {
      final response = await _apiService.updatePerson(
        PersonType.guardian,
        id,
        model.toJson(),
      );

      return GurdianModel.fromJson(response.toJson());
    });
  }
}
