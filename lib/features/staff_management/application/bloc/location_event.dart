import 'package:new_project/features/staff_management/domain/repositories/;ocation_repository.dart';

abstract class LocationEvent {}

class FetchAllLocations extends LocationEvent {
  FetchAllLocations(LocationRepository locationRepository);
}

class FilterAreasByCity extends LocationEvent {
  final String cityId;
  FilterAreasByCity(this.cityId);
}

class FilterStreetsByArea extends LocationEvent {
  final String areaId;
  FilterStreetsByArea(this.areaId);
}
