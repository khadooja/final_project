import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';

class AddChildUseCase {
  final ChildRepository _repository;

  AddChildUseCase(this._repository);

  Future<ApiResult<void>> execute(ChildModel child) async {
    return _repository.addChild(child);
  }
}
