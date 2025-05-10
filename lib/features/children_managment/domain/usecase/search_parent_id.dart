import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

class SearchParentIdUseCase {
  final ChildRepository _repository;

  SearchParentIdUseCase(this._repository);

  Future<ApiResult<PersonModel?>> execute({
    required PersonType type,
    required String identityNumber,
  }) async {
    return _repository.searchParentById(
      type,
      identityNumber,
    );
  }
}
