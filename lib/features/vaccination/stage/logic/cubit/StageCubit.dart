import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:new_project/features/vaccination/stage/data/repos.dart';
import 'package:new_project/features/vaccination/stage/logic/cubit/StageCubit.dart';
import 'package:new_project/features/vaccination/stage/model/StageModel.dart';

part 'stage_state.dart';

class Stagecubit extends Cubit<StageState> {
  final StageRepository repository;

  Stagecubit({required this.repository}) : super(StageInitial());

  Future<void> createStage(Map<String, dynamic> data) async {
    emit(StageLoading());
    try {
      final stage = await repository.createStage(data);
      emit(StageSuccess(stage));
    } catch (e) {
      emit(StageError(e.toString()));
    }
  }
}
