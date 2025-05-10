import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/staff_management/application/bloc/location_event.dart';
import 'package:new_project/features/staff_management/application/bloc/location_state.dart';
import 'package:new_project/features/staff_management/domain/repositories/;ocation_repository.dart';
import 'package:new_project/features/staff_management/domain/usecases/get_areas_by_city.dart';
import 'package:new_project/features/staff_management/domain/usecases/get_streets_by_area.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository repository;
  final GetStreetsByArea getStreetsByArea;
  final GetAreasByCity getAreasByCity;
  final FetchAllLocations fetchAllLocations;

  LocationBloc(
      {required this.repository,
      required this.getStreetsByArea,
      required this.getAreasByCity,
      required this.fetchAllLocations})
      : super(LocationInitial()) {
    on<FetchAllLocations>(_onFetchAllLocations);
    on<FilterAreasByCity>(_onFilterAreasByCity);
    on<FilterStreetsByArea>(_onFilterStreetsByArea);
  }

  void _onFetchAllLocations(
      FetchAllLocations event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final locations = await repository
          .fetchAllLocations(); // تأكد من انتظار البيانات الصحيحة
      emit(LocationLoaded(locations)); // تمرير البيانات إلى الحالة
    } catch (e) {
      emit(LocationError('Failed to load locations'));
    }
  }

  void _onFilterAreasByCity(
      FilterAreasByCity event, Emitter<LocationState> emit) async {
    try {
      final areas = await repository.getAreasByCity(event.cityId);
      emit(AreasFiltered(areas));
    } catch (e) {
      emit(LocationError('Failed to filter areas'));
    }
  }

  void _onFilterStreetsByArea(
      FilterStreetsByArea event, Emitter<LocationState> emit) async {
    try {
      final streets = await repository.getStreetsByArea(event.areaId);
      emit(StreetsFiltered(streets));
    } catch (e) {
      emit(LocationError('Failed to filter streets'));
    }
  }
}
