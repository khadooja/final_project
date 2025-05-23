import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/BaseRemoteDataSource.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

class PersonRemoteDataSourceImpl extends BaseRemoteDataSource
    implements PersonRemoteDataSource {
  final ApiServiceManual _apiService;

  PersonRemoteDataSourceImpl(this._apiService);

  @override
Future<ApiResult<SearchPersonResponse?>> searchPersonById(
  String identityCardNumber,
  PersonType type,
) async {
  return callApi(() => _apiService.searchPerson(
        identityCardNumber,
        type,
      ));
}


  @override
  Future<ApiResult<void>> toggleActivation(
      PersonType type, String id, bool isActive) {
    return callApi(() => _apiService.toggleActivationPerson(
          type,
          id,
          {'is_active': isActive},
        ));
  }

  @override
  Future<ApiResult<(List<NationalityModel>, List<CityModel>)>>
      getNationalitiesAndCities(PersonType type) {
    return callApi(() async {
      final response = await _apiService.getNationalitiesAndCities(type);
        return (response.nationalities,response.cities);
    }
    );
  }

  @override
  Future<ApiResult<List<AreaModel>>> getAreasByCity(
      PersonType type, String cityName) {
    return callApi(() async {
      final response = await _apiService.getAreasByCity(type, cityName);
      return response
          .asMap()
          .entries
          .map((entry) => AreaModel(id: entry.key, area_name: entry.value))
          .toList();
    });
  }
}
