abstract class GuardianState {}

class GuardianInitial extends GuardianState {}

class GuardianLoading extends GuardianState {}

class GuardianAddSuccess extends GuardianState {}

class GuardianUpdateSuccess extends GuardianState {}

class GuardianToggleActivationSuccess extends GuardianState {}

class GuardianFailure extends GuardianState {
  final String error;
  GuardianFailure(this.error);
}

class GuardianLinkSuccess extends GuardianState {}

class GuardianSearchSuccess extends GuardianState {
  final dynamic data;
  GuardianSearchSuccess(this.data);
}

class GuardianFound extends GuardianState {
  final bool isFullGuardian;

  GuardianFound({required this.isFullGuardian});

  @override
  List<Object?> get props => [isFullGuardian];
}

class GuardianNotFound extends GuardianState {}

class GuardianNationalitiesAndCitiesLoaded extends GuardianState {
  final List<dynamic> nationalities;
  final List<dynamic> cities;
  GuardianNationalitiesAndCitiesLoaded(this.nationalities, this.cities);
}
