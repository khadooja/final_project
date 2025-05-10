abstract class LocationRepository {
  Future<List<dynamic>> fetchAllLocations();
  Future<List<dynamic>> getAreasByCity(String cityId);
  Future<List<dynamic>> getStreetsByArea(String areaId);
}
