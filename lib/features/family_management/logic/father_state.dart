import 'package:equatable/equatable.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

abstract class FatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FatherAreasLoaded extends FatherState {
  final List<AreaModel> areas;

  FatherAreasLoaded(this.areas);
}

class FatherDropdownsLoaded extends FatherState {
  final List<NationalityModel> nationalities;
  final List<CityModel> cities;

  FatherDropdownsLoaded({required this.nationalities, required this.cities});
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
