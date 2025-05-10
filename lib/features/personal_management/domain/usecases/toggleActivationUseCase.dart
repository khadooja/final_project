import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class ToggleActivationPersonUseCase {
  final PersonRepository _repository;

  ToggleActivationPersonUseCase(this._repository);

  Future<ApiResult<void>> call(PersonType type, String id, bool isActive) {
    return _repository.toggleActivation(type, id, isActive);
  }
}
