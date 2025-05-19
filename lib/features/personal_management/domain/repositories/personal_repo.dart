import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

abstract class PersonRepository {
  Future<ApiResult<SearchPersonResponse?>> searchPersonById(
    PersonType type,
    String identityCardNumber,
  );

  Future<ApiResult<void>> toggleActivation(
      PersonType type, String personId, bool isActive);
  Future<ApiResult<(List<NationalityModel>, List<CityModel>)>>
      getNationalitiesAndCities(PersonType type);
  Future<ApiResult<List<AreaModel>>> getAreasByCity(
      PersonType type, String cityName);
}
