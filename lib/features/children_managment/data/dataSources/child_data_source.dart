import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/children_managment/data/model/CommonDropdownsChidModel.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/children_managment/data/model/child_list_response_model.dart';

abstract class ChildRemoteDataSource extends PersonRemoteDataSource {
  Future<ApiResult<void>> addChild(Map<String, dynamic> childData);
  Future<ApiResult<void>> updateChild(
      String id, Map<String, dynamic> childData);
  Future<ApiResult<CommonDropdownsChidModel>> getNationalitiesAndCitiesandCases(
      PersonType type);

  Future<ApiResult<ChildListResponseModel>> getChildren(); // New method
}
