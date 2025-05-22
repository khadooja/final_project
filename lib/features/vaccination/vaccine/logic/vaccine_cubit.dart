// logic/vaccine_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/vaccination/stage/model/StageModel.dart';
import 'package:new_project/features/vaccination/vaccine/model/SimpleVaccineModel.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';
import '../data/vaccine_repository.dart';
part 'vaccine_state.dart';

class VaccineCubit extends Cubit<VaccineState> {
  final VaccineRepository repository;

  VaccineCubit({required this.repository}) : super(VaccineLoading());

  void fetchVaccines() async {
    emit(VaccineLoading());
    try {
      final vaccines = await repository.getVaccines();
      emit(VaccineLoaded(vaccines));
    } catch (e) {
      emit(VaccineError("فشل في تحميل قائمة التطعيمات"));
    }
  }

  Future<void> loadVaccines() async {
    emit(VaccineLoading());

    final response = await repository.fetchVaccinesWithCount();

    final List dataList = response['data'];
    final List<VaccineModel> vaccines =
        List<VaccineModel>.from(response['data']);

    final count = response['count'] as int;

    emit(VaccineLoaded1(vaccines, count));
  }

  Future<void> toggleStatus(int id) async {
    await repository.toggleStatus(id);
    await loadVaccines();
  }

  Future<void> getStages() async {
    try {
      emit(VaccineLoading());
      final stages = await repository.fetchStages();
      emit(VaccineStagesLoaded(stages));
    } catch (e) {
      emit(VaccineError("فشل في تحميل المراحل"));
    }
  }

  Future<void> addVaccine(VaccineModel vaccine) async {
    try {
      emit(VaccineLoading());
      final success = await repository.addVaccine(vaccine);
      if (success) {
        emit(VaccineAdded());
      } else {
        emit(VaccineError("فشل في إضافة التطعيم"));
      }
    } catch (e) {
      emit(VaccineError("حدث خطأ أثناء إضافة التطعيم"));
    }
  }
}
