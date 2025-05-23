import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource _remoteDataSource;

  PersonRepositoryImpl(this._remoteDataSource);

  @override
Future<ApiResult<SearchPersonResponse?>> searchPersonById(String identityCardNumber, PersonType type) {
  return _remoteDataSource.searchPersonById(
    identityCardNumber,
    type,
  );
}

  @override
  Future<ApiResult<void>> toggleActivation(
      PersonType type, String id, bool isActive) {
    return _remoteDataSource.toggleActivation(type, id, isActive);
  }

  @override
  Future<ApiResult<(List<NationalityModel>, List<CityModel>)>>
      getNationalitiesAndCities(PersonType type) {
    return _remoteDataSource.getNationalitiesAndCities(type);
  }

  @override
  Future<ApiResult<List<AreaModel>>> getAreasByCity(
      PersonType type, String cityName) {
    return _remoteDataSource.getAreasByCity(type, cityName);
  }
}
