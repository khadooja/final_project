import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';

abstract class GuardianRepository {
  Future<ApiResult<GurdianModel>> addGuardian(GurdianModel guardianModel);
  Future<ApiResult<GurdianModel>> updateGuardian(String id, GurdianModel model);
}
