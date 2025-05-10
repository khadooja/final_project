import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/dataSources/fatherRemoteDataSource.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';

class FatherRepositoryImpl implements FatherRepository {
  final FatherRemoteDataSource _remoteDataSource;

  FatherRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<FatherModel>> addFather(FatherModel father) {
    return _remoteDataSource.addFather(father);
  }

  @override
  Future<ApiResult<FatherModel>> updateFather(String id, FatherModel father) {
    return _remoteDataSource.updateFather(id, father);
  }
}
