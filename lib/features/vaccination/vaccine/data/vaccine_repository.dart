import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/vaccination/vaccine/model/SimpleVaccineModel.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';

class VaccineRepository {
  final ApiServiceManual api;

  VaccineRepository(this.api);

  Future<List<SimpleVaccineModel>> getVaccines() async {
    return await api.getVaccines();
  }
}
