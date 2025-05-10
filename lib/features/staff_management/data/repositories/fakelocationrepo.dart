import 'package:new_project/features/staff_management/data/datasources/fakelocationRemoteDataSource.dart';
import 'package:new_project/features/staff_management/domain/repositories/;ocation_repository.dart';

class MockLocationRemoteDataSource implements LocationRepository {
  final FakeLocationRemoteDataSource remoteDataSource;

  MockLocationRemoteDataSource({required this.remoteDataSource});

  @override
  Future<List<dynamic>> fetchAllLocations() async {
    return remoteDataSource.fetchAllLocations();
  }

  @override
  Future<List<dynamic>> getAreasByCity(String cityId) async {
    return remoteDataSource.getAreasByCity(cityId);
  }

  @override
  Future<List<dynamic>> getStreetsByArea(String areaId) async {
    return remoteDataSource.getStreetsByArea(areaId);
  }
}
