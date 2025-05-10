import 'package:equatable/equatable.dart';

abstract class FatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FatherAddSuccess extends FatherState {}

class FatherUpdateSuccess extends FatherState {}

class FatherInitial extends FatherState {}

class FatherLoading extends FatherState {}

class FatherFound extends FatherState {
  final bool isFullFather;

  FatherFound({required this.isFullFather});

  @override
  List<Object?> get props => [isFullFather];
}

class FatherNotFound extends FatherState {}

class FatherToggleActivationSuccess extends FatherState {}

class FatherError extends FatherState {
  final String message;

  FatherError(this.message);

  @override
  List<Object?> get props => [message];
}

class FatherNationalitiesAndCitiesLoaded extends FatherState {
  final List<dynamic> nationalities;
  final List<dynamic> cities;
  FatherNationalitiesAndCitiesLoaded(this.nationalities, this.cities);
}
