import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class LocationRemoteDataSource {
  final Dio dio;
  final String baseUrl;
  final Box cacheBox;

  LocationRemoteDataSource(
      {required this.dio, required this.baseUrl, required this.cacheBox});

  Future<void> fetchAllLocations() async {
    if (cacheBox.containsKey('all_locations')) {
      return; // ✅ لا تعيد الجلب إذا كان مخزنًا
    }

    try {
      final response = await dio.get('$baseUrl/all_locations');
      cacheBox.put('all_locations', response.data); // ✅ تخزينها في الكاش
    } catch (e) {
      throw Exception('Failed to fetch locations: ${e.toString()}');
    }
  }

  List<dynamic> getAreasByCity(String cityId) {
    final data = cacheBox.get('all_locations', defaultValue: []);
    return data.where((area) => area['city_id'].toString() == cityId).toList();
  }

  List<dynamic> getStreetsByArea(String areaId) {
    final data = cacheBox.get('all_locations', defaultValue: []);
    return data
        .where((street) => street['area_id'].toString() == areaId)
        .toList();
  }
}
