import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/vaccination/stage/model/StageModel.dart';
import 'package:new_project/features/vaccination/vaccine/model/SimpleVaccineModel.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';

class VaccineRepository {
  final ApiServiceManual api;

  VaccineRepository({required this.api});

  Future<List<SimpleVaccineModel>> getVaccines() async {
    return await api.getVaccines();
  }

  Future<Map<String, dynamic>> fetchVaccinesWithCount() async {
    final response =
        await api.getVaccine(); // هذه تستخدم دالة موجودة في ApiServiceManual
    final count = response['count'] as int;
    final List dataList = response['data'];

    final vaccines = dataList.map((e) => VaccineModel.fromJson(e)).toList();

    return {
      'count': count,
      'data': vaccines,
    };
  }

  Future<void> updateVaccine(int id, VaccineModel model) async =>
      api.updateVaccine(id, model);

  Future<void> toggleStatus(int id) async => api.toggleVaccineStatus(id);

  Future<Map<String, dynamic>> getEditData(int id) async =>
      api.getVaccineEditData(id);

  Future<List<StageModel>> fetchStages() async {
    return await api.fetchStages();
  }

  Future<bool> addVaccine(VaccineModel vaccine) async {
    return await api.addVaccine(vaccine);
  }
}
