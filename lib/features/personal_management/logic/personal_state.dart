import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';

abstract class PersonState {}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonSearchSuccess extends PersonState {
  final PersonModel? person;

  PersonSearchSuccess(this.person);
}

class PersonalLoading extends PersonState {}

class PersonToggleActivationSuccess extends PersonState {}

class PersonNationalitiesAndCitiesLoaded extends PersonState {
  final List<NationalityModel> nationalities;
  final List<CityModel> cities;

  PersonNationalitiesAndCitiesLoaded(this.nationalities, this.cities);
}

class PersonAreasLoaded extends PersonState {
  final List<AreaModel> areas;

  PersonAreasLoaded(this.areas);
}

class PersonFailure extends PersonState {
  final String message;

  PersonFailure(this.message);
}
