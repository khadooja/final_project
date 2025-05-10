import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/dataSources/motherRemoteDataSource.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/family_management/domain/repository/motherRepository.dart';

class MotherRepositoryImpl implements MotherRepository {
  final MotherRemoteDataSource _remoteDataSource;

  MotherRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<MotherModel>> addMother(MotherModel mother) {
    return _remoteDataSource.addMother(mother);
  }

  @override
  Future<ApiResult<MotherModel>> updateMother(
      String motherId, MotherModel mother) {
    return _remoteDataSource.updateMother(motherId, mother);
  }
}
