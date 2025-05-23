import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class SearchPersonByIdUseCase {
  final PersonRepository _repository;

  SearchPersonByIdUseCase(this._repository);

  Future<ApiResult<SearchPersonResponse?>> call(String identityCardNumber ,PersonType type) {
    return _repository.searchPersonById( identityCardNumber,type);
  }
}
