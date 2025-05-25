import 'package:equatable/equatable.dart';
import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/child_edit_details_model.dart';
import 'package:new_project/features/children_managment/data/model/child_list_response_model.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

abstract class ChildState extends Equatable {
  const ChildState(); // Add const
  @override
  List<Object?> get props => [];
}

class ChildInitial extends ChildState {}

// Generic loading for list, add, update, details
class ChildLoading extends ChildState {} // Can be used for add/update loading

class ChildDetailsLoading
    extends ChildState {} // For loading details specifically

class ChildLoadingDropdowns extends ChildState {}

// List states
class ChildrenListLoading extends ChildState {}

class ChildrenListLoaded extends ChildState {
  final ChildListResponseModel childrenResponse;
  const ChildrenListLoaded(this.childrenResponse); // Add const
  @override
  List<Object?> get props => [childrenResponse];
}

class ChildrenListError extends ChildState {
  final String message;
  const ChildrenListError(this.message); // Add const
  @override
  List<Object?> get props => [message];
}

// Details for Edit states (Using ChildEditDetailsModel)
class ChildDetailsForEditLoaded extends ChildState {
  // Renamed from ChildDetailsLoaded or ChildEditDetailsLoaded
  final ChildEditDetailsModel childDetails; // Use the chosen model
  const ChildDetailsForEditLoaded(this.childDetails); // Add const
  @override
  List<Object> get props => [childDetails];
}

class ChildDetailsError extends ChildState {
  // This can be a general details error state
  final String message;
  const ChildDetailsError(this.message); // Add const
  @override
  List<Object?> get props => [message];
}

// Save/Update states
class ChildSaveSuccess extends ChildState {
  final String message;
  final bool isEdit;
  const ChildSaveSuccess(
      {required this.message, required this.isEdit}); // Add const
  @override
  List<Object?> get props => [message, isEdit];
}

class ChildSaveError extends ChildState {
  final String message;
  const ChildSaveError(this.message); // Add const
  @override
  List<Object?> get props => [message];
}

// Dropdown data loaded (primarily for "Add New" or if fetched separately)
class ChildLoadedDropdowns extends ChildState {
  final List<NationalityModel>
      nationalities; // Or NationalityOptionModel if you align them
  final List<CountryModel> countries; // Or CountryOptionModel
  final List<SpecialCase> specialCases; // Or SpecialCaseOptionModel

  const ChildLoadedDropdowns({
    // Add const
    required this.nationalities,
    required this.countries,
    required this.specialCases,
  });
  @override
  List<Object?> get props => [nationalities, countries, specialCases];
}


// Remove redundant states if they are covered by the ones above
// class ChildFailure extends ChildState { ... } // Covered by ChildSaveError / ChildDetailsError / ChildrenListError
// class ChildSuccess extends ChildState { ... } // Covered by ChildSaveSuccess