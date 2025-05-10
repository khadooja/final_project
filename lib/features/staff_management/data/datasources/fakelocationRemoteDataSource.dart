class FakeLocationRemoteDataSource {
  final List<Map<String, String>> cities = [
    {"id": "1", "name": "الرياض"},
    {"id": "2", "name": "جدة"},
    {"id": "3", "name": "الدمام"},
  ];

  final List<Map<String, String>> areas = [
    {"id": "1", "city_id": "1", "name": "العليا"},
    {"id": "2", "city_id": "1", "name": "الملز"},
    {"id": "3", "city_id": "2", "name": "السلامة"},
  ];

  final List<Map<String, String>> streets = [
    {"id": "1", "area_id": "1", "name": "شارع الملك فهد"},
    {"id": "2", "area_id": "2", "name": "شارع الأمير سلطان"},
  ];

  Future<List<Map<String, String>>> fetchAllLocations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [...cities, ...areas, ...streets];
  }

  Future<List<Map<String, String>>> getAreasByCity(String cityId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return areas.where((area) => area["city_id"] == cityId).toList();
  }

  Future<List<Map<String, String>>> getStreetsByArea(String areaId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return streets.where((street) => street["area_id"] == areaId).toList();
  }
}
