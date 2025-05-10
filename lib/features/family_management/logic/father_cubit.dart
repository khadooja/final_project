import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import '../../personal_management/domain/repositories/personal_repo.dart';

class FatherCubit extends Cubit<FatherState> {
  final FatherRepository _fatherRepository;
  final PersonRepository _personRepository;

  FatherCubit(this._fatherRepository, this._personRepository)
      : super(FatherInitial());

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final identityController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  // Dropdown selections
  String? selectedGender;
  int? selectedNationalityId;
  int? selectedCityId;
  int? selectedAreaId;
  bool isDead = false;

  // Helper methods to clear and fill the form
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    identityController.clear();
    birthDateController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    selectedGender = null;
    selectedNationalityId = null;
    selectedCityId = null;
    selectedAreaId = null;
    isDead = false;
  }

  void fillFormWithFather(FatherModel model) {
    firstNameController.text = model.firstName;
    lastNameController.text = model.lastName;
    identityController.text = model.identityCardNumber;
    birthDateController.text = model.birthDate.toString();
    phoneController.text = model.phoneNumber ?? '';
    emailController.text = model.email ?? '';
    selectedGender = model.gender;
    selectedNationalityId = model.nationalitiesId;
    selectedAreaId = model.locationId;
    isDead = model.isDeceased ?? false;
  }

  void fillFormWithPerson(PersonModel model) {
    firstNameController.text = model.firstName;
    lastNameController.text = model.lastName;
    identityController.text = model.identityCardNumber;
    selectedGender = model.gender;
    selectedNationalityId = model.nationalitiesId;
    selectedAreaId = model.locationId;
  }

  // Search for father by identity
  Future<void> searchByIdentity(PersonType type, String identity) async {
    emit(FatherLoading());

    final result = await _personRepository.searchPersonById(type, identity);

    result.when(
      success: (person) {
        if (person is FatherModel) {
          fillFormWithFather(person);
          emit(FatherFound(isFullFather: true));
        } else if (person is PersonModel) {
          fillFormWithPerson(person);
          emit(FatherFound(isFullFather: false));
        } else {
          clearForm();
          emit(FatherNotFound());
        }
      },
      failure: (error) {
        clearForm();
        emit(FatherError("فشل البحث: ${error.message}"));
      },
    );
  }

  // Add a new father
  Future<void> addFather(FatherModel model) async {
    emit(FatherLoading());
    final result = await _fatherRepository.addFather(model);

    result.when(
      success: (_) => emit(FatherAddSuccess()),
      failure: (error) {
        emit(FatherError(error.message));
      },
    );
  }

  // Update an existing father's information
  Future<void> updateFather(String id, FatherModel model) async {
    emit(FatherLoading());
    final result = await _fatherRepository.updateFather(id, model);

    result.when(
      success: (_) => emit(FatherUpdateSuccess()),
      failure: (error) {
        emit(FatherError(error.message));
      },
    );
  }

  // Toggle the activation status of the father
  Future<void> toggleActivation(String id) async {
    emit(FatherLoading());
    final result =
        await _personRepository.toggleActivation(PersonType.father, id, true);

    result.when(
      success: (_) => emit(FatherToggleActivationSuccess()),
      failure: (error) {
        emit(FatherError(error.message));
      },
    );
  }

  // Submit father's data (either add or update)
  Future<void> submitFather({String? fatherId}) async {
    final fatherModel = FatherModel(
      id: fatherId != null ? int.parse(fatherId) : 0,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      identityCardNumber: identityController.text,
      birthDate: DateTime.parse(
          birthDateController.text), // Adjust the format if necessary
      phoneNumber: phoneController.text,
      email: emailController.text,
      nationalitiesId: selectedNationalityId ?? 0,
      locationId: selectedAreaId ?? 0,
      isDeceased: isDead,
      isActive: true,
      childCount: 0, // Default value for now
      gender: selectedGender ?? 'male', // Default to 'male' if not selected
    );

    if (fatherId != null) {
      updateFather(fatherId, fatherModel);
    } else {
      addFather(fatherModel);
    }
  }
}
