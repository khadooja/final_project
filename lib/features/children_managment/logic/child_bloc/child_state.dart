import 'package:equatable/equatable.dart';
import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/child_list_response_model.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

abstract class ChildState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChildInitial extends ChildState {}

class ChildLoading extends ChildState {}

class ChildSuccess extends ChildState {
  final String message;
  ChildSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChildFailure extends ChildState {
  final String message;
  ChildFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ChildLoadingDropdowns extends ChildState {}

class ChildLoadedDropdowns extends ChildState {
  final List<NationalityModel> nationalities;
  final List<CountryModel> countries;
  final List<SpecialCase> specialCases;

  ChildLoadedDropdowns({
    required this.nationalities,
    required this.countries,
    required this.specialCases,
  });

  @override
  List<Object?> get props => [nationalities, countries, specialCases];
}

class ChildrenListLoading extends ChildState {}

class ChildrenListLoaded extends ChildState {
  final ChildListResponseModel childrenResponse;
  ChildrenListLoaded(this.childrenResponse);

  @override
  List<Object?> get props => [childrenResponse];
}

class ChildrenListError extends ChildState {
  final String message;
  ChildrenListError(this.message);

  @override
  List<Object?> get props => [message];
}
