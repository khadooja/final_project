import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';

class AddGuardianUseCase {
  final ChildGuardianRepository repository;

  AddGuardianUseCase(this.repository);

  Future<ApiResult<void>> execute(GurdianModel model) {
    return repository.addGuardian(model);
  }
}
