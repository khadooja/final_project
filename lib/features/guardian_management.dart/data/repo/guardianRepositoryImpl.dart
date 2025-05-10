import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/guardian_repository.dart';

class GuardianRepositoryImpl implements GuardianRepository {
  final GuardianRemoteDataSource _guardianRepository;

  GuardianRepositoryImpl(this._guardianRepository);

  @override
  Future<ApiResult<GurdianModel>> addGuardian(GurdianModel model) {
    return _guardianRepository.addGuardian(model);
  }

  @override
  Future<ApiResult<GurdianModel>> updateGuardian(
      String id, GurdianModel model) {
    return _guardianRepository.updateGuardian(id, model);
  }
}
