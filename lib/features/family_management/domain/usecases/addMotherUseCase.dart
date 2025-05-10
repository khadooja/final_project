import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/family_management/domain/repository/motherRepository.dart';

class AddMotherUseCase {
  final MotherRepository repository;

  AddMotherUseCase(this.repository);

  Future<ApiResult<void>> execute(MotherModel model) {
    return repository.addMother(model);
  }
}
