// logic/vaccine_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';
import '../data/vaccine_repository.dart';
part 'vaccine_state.dart';

class VaccineCubit extends Cubit<VaccineState> {
  final VaccineRepository repository;

  VaccineCubit(this.repository) : super(VaccineInitial());

  void fetchVaccines() async {
    emit(VaccineLoading());
    try {
      final vaccines = await repository.getVaccines();
      emit(VaccineLoaded(vaccines));
    } catch (e) {
      emit(VaccineError("فشل في تحميل قائمة التطعيمات"));
    }
  }
}
