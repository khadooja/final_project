import 'package:new_project/features/personal_management/data/models/SimpleNationalityModel.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

abstract class PersonState {}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonSearchSuccess extends PersonState {
  final SearchPersonResponse? response;
  PersonSearchSuccess(this.response);
}


class PersonalLoading extends PersonState {}

class PersonToggleActivationSuccess extends PersonState {}

class PersonNationalitiesAndCitiesLoaded extends PersonState {
  final List<SimpleNationalityModel> nationalities;
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
