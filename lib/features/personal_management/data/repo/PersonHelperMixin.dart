import 'package:new_project/Core/helpers/dropdown_helper/dropdown_storage_helper.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/common_dropdowns_response.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';
import 'package:new_project/Core/networking/api_result.dart';

mixin PersonHelperMixin {
  late final PersonRepository personRepository;

  List<NationalityModel> nationalities = [];
  List<CityModel> cities = [];
  List<AreaModel> areas = [];

  int? selectedNationalityId;
  String? selectedCity;
  int? selectedAreaId;

  void setRepository(PersonRepository repo) {
    personRepository = repo;
  }

  Future<ApiResult<CommonDropDownsResponse>> getNationalitiesAndCities(PersonType type) async {
    final cachedData = await DropdownStorageHelper.getDropdownsData();

    if (cachedData != null) {
      nationalities = cachedData.nationalities;
      cities = cachedData.cities;
      return ApiResult.success(cachedData);
    }

    final result = await personRepository.getNationalitiesAndCities(type);
    return result.when(
      success: (data) async {
        nationalities = data.$1;
        cities = data.$2;
        final response = CommonDropDownsResponse(nationalities: data.$1, cities: data.$2);
        await DropdownStorageHelper.saveDropdownsData(response);
        return ApiResult.success(response);
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  Future<ApiResult<List<AreaModel>>> loadAreasByCityId(PersonType type, String cityName) async {
    final result = await personRepository.getAreasByCity(type, cityName);
    return result.when(
      success: (data) {
        areas = data;
        return ApiResult.success(data);
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  void setNationality(int? id) {
    selectedNationalityId = id;
  }

  void setCity(String? city) {
    selectedCity = city;
  }

  void setArea(int? id) {
    selectedAreaId = id;
  }
}
