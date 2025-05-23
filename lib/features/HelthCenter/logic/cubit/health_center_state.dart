// vaccination/logic/health_center/health_center_state.dart

part of 'health_center_cubit.dart';

abstract class HealthCenterState {}

class HealthCenterInitial extends HealthCenterState {}

class HealthCenterLoading extends HealthCenterState {}

class HealthCenterUpdated extends HealthCenterState {}

class CitiesLoaded extends HealthCenterState {
  final List<Location> cities;
  CitiesLoaded(this.cities);
}

class AreasLoaded extends HealthCenterState {
  final List<Location> areas;
  AreasLoaded(this.areas);
}

class HealthCenterLoaded extends HealthCenterState {
  final List<HealthCenterDisplay> centers;
  final int count;

  HealthCenterLoaded({required this.centers, required this.count});
}

class HealthCenterAdded extends HealthCenterState {}

class HealthCenterError extends HealthCenterState {
  final String message;
  HealthCenterError(this.message);
}
