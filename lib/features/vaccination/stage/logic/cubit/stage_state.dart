// lib/vaccination/logic/cubit/dose_state.dart

part of 'StageCubit.dart';

abstract class StageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StageInitial extends StageState {}

class StageLoading extends StageState {}

class StageSuccess extends StageState {
  final StageModel stage;

  StageSuccess(this.stage);

  @override
  List<Object?> get props => [stage];
}

class StageError extends StageState {
  final String message;

  StageError(this.message);

  @override
  List<Object?> get props => [message];
}
