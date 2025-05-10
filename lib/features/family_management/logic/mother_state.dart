abstract class MotherState {}

class MotherInitial extends MotherState {}

class MotherLoading extends MotherState {}

class MotherAddSuccess extends MotherState {}

class MotherUpdateSuccess extends MotherState {}

class MotherToggleActivationSuccess extends MotherState {}

class MotherFailure extends MotherState {
  final String error;
  MotherFailure(this.error);
}

class MotherSearchSuccess extends MotherState {
  final dynamic data;
  MotherSearchSuccess(this.data);
}

class MotherNationalitiesAndCitiesLoaded extends MotherState {
  final List<dynamic> nationalities;
  final List<dynamic> cities;
  MotherNationalitiesAndCitiesLoaded(this.nationalities, this.cities);
}
