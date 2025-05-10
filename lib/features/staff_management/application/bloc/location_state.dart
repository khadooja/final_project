abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<dynamic> locations;
  LocationLoaded(this.locations);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class AreasFiltered extends LocationState {
  final List<dynamic> areas;
  AreasFiltered(this.areas);
}

class StreetsFiltered extends LocationState {
  final List<dynamic> streets;
  StreetsFiltered(this.streets);
}
