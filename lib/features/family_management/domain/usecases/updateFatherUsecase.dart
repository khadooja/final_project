import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';

class UpdateFatherUseCase {
  final FatherRepository repository;

  UpdateFatherUseCase({required this.repository});

  Future<ApiResult<FatherModel>> execute(
      String fatherId, FatherModel fatherModel) async {
    return await repository.updateFather(fatherId, fatherModel);
  }
}
