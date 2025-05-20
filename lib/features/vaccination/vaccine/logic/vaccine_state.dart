// logic/vaccine_state.dart
part of 'vaccine_cubit.dart';

abstract class VaccineState {}

class VaccineInitial extends VaccineState {}

class VaccineLoading extends VaccineState {}

class VaccineLoaded extends VaccineState {
  final List<VaccineModel> vaccines;

  VaccineLoaded(this.vaccines);
}

class VaccineError extends VaccineState {
  final String message;

  VaccineError(this.message);
}
