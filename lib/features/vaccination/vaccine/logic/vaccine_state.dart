// logic/vaccine_state.dart
part of 'vaccine_cubit.dart';

abstract class VaccineState {}

class VaccineInitial extends VaccineState {}

class VaccineLoading extends VaccineState {}

class VaccineLoaded extends VaccineState {
  final List<SimpleVaccineModel> vaccines;

  VaccineLoaded(this.vaccines);
}

class VaccineLoaded1 extends VaccineState {
  final int count;
  final List<VaccineModel> vaccines;
  VaccineLoaded1(this.vaccines, this.count);
}

class VaccineStagesLoaded extends VaccineState {
  final List<StageModel> stages;
  VaccineStagesLoaded(this.stages);
}

class VaccineAdded extends VaccineState {}

class VaccineError extends VaccineState {
  final String message;

  VaccineError(this.message);
}
