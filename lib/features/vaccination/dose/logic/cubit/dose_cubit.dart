import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/vaccination/dose/data/repos/dose_repo.dart';
import 'package:new_project/features/vaccination/dose/model/dose_model.dart';

part 'dose_state.dart';

class DoseCubit extends Cubit<DoseState> {
  final DoseRepository repository;

  DoseCubit({required this.repository}) : super(DoseInitial());

  Future<void> createDose(Map<String, dynamic> data) async {
    emit(DoseLoading());
    try {
      final dose = await repository.createDose(data);
      emit(DoseSuccess(dose));
    } catch (e) {
      emit(DoseError(e.toString()));
    }
  }
}
