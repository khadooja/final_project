import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class GetAreasByCityUseCase {
  final PersonRepository _repository;

  GetAreasByCityUseCase(this._repository);

  Future<ApiResult<List<AreaModel>>> call(PersonType type, String cityName) {
    return _repository.getAreasByCity(type, cityName);
  }
}
