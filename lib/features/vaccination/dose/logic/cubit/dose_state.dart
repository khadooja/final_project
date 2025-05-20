// lib/vaccination/logic/cubit/dose_state.dart

part of 'dose_cubit.dart';

abstract class DoseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DoseInitial extends DoseState {}

class DoseLoading extends DoseState {}

class DoseSuccess extends DoseState {
  final DoseModel dose;

  DoseSuccess(this.dose);

  @override
  List<Object?> get props => [dose];
}

class DoseError extends DoseState {
  final String message;

  DoseError(this.message);

  @override
  List<Object?> get props => [message];
}
