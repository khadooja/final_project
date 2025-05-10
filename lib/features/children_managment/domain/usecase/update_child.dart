import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';

class UpdateChildUseCase {
  final ChildRepository _repository;

  UpdateChildUseCase(this._repository);

  Future<ApiResult<void>> updateChild(
      String id, Map<String, dynamic> data) async {
    return _repository.updateChild(id, data);
  }
}
