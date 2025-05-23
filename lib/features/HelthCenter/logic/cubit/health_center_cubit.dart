// vaccination/logic/health_center/health_center_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/HelthCenter/data/repository/health_center_repository.dart';
import 'package:new_project/features/HelthCenter/model/helth_center.dart';
import 'package:new_project/features/HelthCenter/model/location.dart';

import '../../model/HealthCenterDisplay.dart';

part 'health_center_state.dart';

class HealthCenterCubit extends Cubit<HealthCenterState> {
  final HealthCenterRepository repository;

  HealthCenterCubit({required this.repository}) : super(HealthCenterInitial());

  Future<void> fetchCities() async {
    emit(HealthCenterLoading());
    try {
      final cities = await repository.getCities();
      emit(CitiesLoaded(cities));
    } catch (e) {
      emit(HealthCenterError('فشل تحميل المدن'));
    }
  }

  Future<void> fetchAreas(String cityName) async {
    emit(HealthCenterLoading());
    try {
      final areas = await repository.getAreas(cityName);
      emit(AreasLoaded(areas));
    } catch (e) {
      emit(HealthCenterError('فشل تحميل المناطق'));
    }
  }

  Future<void> addCenter(HealthCenter center) async {
    emit(HealthCenterLoading());
    try {
      final success = await repository.createHealthCenter(center);
      if (success) {
        emit(HealthCenterAdded());
      } else {
        emit(HealthCenterError('فشل في الإضافة'));
      }
    } catch (e) {
      emit(HealthCenterError('حدث خطأ أثناء الإضافة'));
    }
  }

  Future<void> loadHealthCenters() async {
    try {
      emit(HealthCenterLoading());
      final centers =
          await repository.fetchHealthCenters(); // نوعها HealthCenterDisplay
      final count = await repository.fetchCount();
      emit(HealthCenterLoaded(centers: centers, count: count));
    } catch (e) {
      emit(HealthCenterError(e.toString()));
    }
  }

  Future<void> toggleStatus(int id) async {
    await repository.toggleStatus(id);
    await loadHealthCenters();
  }

  Future<void> updateHealthCenter(
      {required int id, required HealthCenter model}) async {
    try {
      final success = await repository.updateHealth(id, model);

      emit(HealthCenterUpdated());
    } catch (e) {
      emit(HealthCenterError('فشل تعديل المستوصف: $e'));
    }
  }
}
