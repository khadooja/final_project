import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/children_managment/data/model/child_list_response_model.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';

class GetChildrenUseCase {
  final ChildRepository _repository;

  GetChildrenUseCase(this._repository);

  Future<ApiResult<ChildListResponseModel>> execute() async {
    return _repository.getChildren();
  }
}
