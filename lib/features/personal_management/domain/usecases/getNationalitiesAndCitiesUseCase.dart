import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class GetNationalitiesAndCitiesUseCase {
  final PersonRepository _repository;

  GetNationalitiesAndCitiesUseCase(this._repository);

  Future<ApiResult<(List<NationalityModel>, List<CityModel>)>> call(
      PersonType type) {
    return _repository.getNationalitiesAndCities(type);
  }
}
