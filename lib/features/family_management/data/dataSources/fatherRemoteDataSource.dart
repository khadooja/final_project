import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';

abstract class FatherRemoteDataSource extends PersonRemoteDataSource {
  Future<ApiResult<FatherModel>> addFather(FatherModel fatherModel);
  Future<ApiResult<FatherModel>> updateFather(
      String fatherId, FatherModel fatherModel);
}
