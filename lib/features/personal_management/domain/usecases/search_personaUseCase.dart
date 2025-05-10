import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class SearchPersonByIdUseCase {
  final PersonRepository _repository;

  SearchPersonByIdUseCase(this._repository);

  Future<ApiResult<PersonModel?>> call(PersonType type, String id) {
    return _repository.searchPersonById(type, id);
  }
}
