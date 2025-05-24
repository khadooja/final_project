import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/SimpleNationalityModel.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

abstract class PersonRemoteDataSource {
  Future<ApiResult<SearchPersonResponse?>> searchPersonById(

    String identityCardNumber,    PersonType type,
  );

  Future<ApiResult<void>> toggleActivation(
      PersonType type, String personId, bool isActive);
  Future<ApiResult<(List<SimpleNationalityModel>, List<CityModel>)>>
      getNationalitiesAndCities(PersonType type);
  Future<ApiResult<List<Map<String, dynamic>>>> getAreasByCity(
      PersonType type, String cityName);
}
