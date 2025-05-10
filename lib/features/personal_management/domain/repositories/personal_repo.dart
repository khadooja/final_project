import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

abstract class PersonRepository {
  Future<ApiResult<PersonModel?>> searchPersonById(
      PersonType type, String identityCardNumber);
  Future<ApiResult<void>> toggleActivation(
      PersonType type, String personId, bool isActive);
  Future<ApiResult<(List<NationalityModel>, List<CityModel>)>>
      getNationalitiesAndCities(PersonType type);
  Future<ApiResult<List<AreaModel>>> getAreasByCity(
      PersonType type, String cityName);
}
