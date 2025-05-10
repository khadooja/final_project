import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';

abstract class MotherRepository {
  Future<ApiResult<MotherModel>> addMother(MotherModel model);
  Future<ApiResult<MotherModel>> updateMother(
      String motherId, MotherModel motherModel);
}
