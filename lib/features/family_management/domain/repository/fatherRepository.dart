import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';

abstract class FatherRepository {
  Future<ApiResult<FatherModel>> addFather(FatherModel model);
  Future<ApiResult<FatherModel>> updateFather(
      String fatherId, FatherModel fatherModel);
}
