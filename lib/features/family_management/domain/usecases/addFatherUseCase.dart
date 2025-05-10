import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';

class AddFatherUseCase {
  final FatherRepository repository;

  AddFatherUseCase(this.repository);

  Future<ApiResult<void>> execute(FatherModel model) {
    return repository.addFather(model);
  }
}
