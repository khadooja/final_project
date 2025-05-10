import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';

abstract class MotherRemoteDataSource extends PersonRemoteDataSource {
  Future<ApiResult<MotherModel>> addMother(MotherModel motherModel);

  Future<ApiResult<MotherModel>> updateMother(
      String motherId, MotherModel motherModel);
}
