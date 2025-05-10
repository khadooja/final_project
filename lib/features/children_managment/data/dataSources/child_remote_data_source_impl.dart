import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_data_source.dart';
import 'package:new_project/features/children_managment/data/model/CommonDropdownsChidModel.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

class ChildRemoteDataSourceImpl extends PersonRemoteDataSourceImpl
    implements ChildRemoteDataSource {
  final ApiServiceManual _apiService;

  ChildRemoteDataSourceImpl(this._apiService) : super(_apiService);

  @override
  Future<ApiResult<void>> addChild(Map<String, dynamic> childData) async {
    try {
      final childModel = ChildModel.fromJson(childData);
      await _apiService.addChild(childModel);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> updateChild(
      String id, Map<String, dynamic> childData) async {
    try {
      final childModel = ChildModel.fromJson(childData);
      await _apiService.updateChild(id, childModel);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<CommonDropdownsChidModel>> getNationalitiesAndCitiesandCases(
      PersonType type) async {
    try {
      final result = await _apiService.getNationalitiesAndCitiesUseCase(type);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
