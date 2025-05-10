import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/family_management/domain/repository/motherRepository.dart';

class UpdateMotherUseCase {
  final MotherRepository repository;

  UpdateMotherUseCase({required this.repository});

  Future<ApiResult<MotherModel>> execute(
      String motherId, MotherModel motherModel) async {
    return await repository.updateMother(motherId, motherModel);
  }
}
