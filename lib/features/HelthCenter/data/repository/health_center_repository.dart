import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/HelthCenter/model/helth_center.dart';
import 'package:new_project/features/HelthCenter/model/location.dart';

import '../../model/HealthCenterDisplay.dart';

class HealthCenterRepository {
  final ApiServiceManual api;

  HealthCenterRepository({required this.api});

  Future<List<Location>> getCities() => api.fetchCities();

  Future<List<Location>> getAreas(String cityName) => api.fetchAreas(cityName);

  Future<bool> createHealthCenter(HealthCenter center) =>
      api.addHealthCenter(center);
  Future<List<HealthCenterDisplay>> fetchHealthCenters() async {
    final data = await api.fetchClinics();
    final list = data['data'] as List;
    return list.map((json) => HealthCenterDisplay.fromJson(json)).toList();
  }

  Future<int> fetchCount() async {
    final data = await api.fetchClinics();
    return data['count'];
  }

  Future<void> toggleStatus(int id) async => api.toggleHealthStatus(id);

  Future<void> updateHealth(int id, HealthCenter model) async =>
      api.updateHealth(id, model);

  Future<Map<String, dynamic>> getEditData(int id) async =>
      api.getHealthEditData(id);
}
