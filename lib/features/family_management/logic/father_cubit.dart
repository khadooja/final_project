import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/repo/PersonHelperMixin.dart';
import '../../personal_management/domain/repositories/personal_repo.dart';

class FatherCubit extends Cubit<FatherState> with PersonHelperMixin {
  FatherCubit(FatherRepository repo, PersonRepository personRepo)
      : _fatherRepository = repo,
        super(FatherInitial()) {
    setRepository(personRepo);
  }

  final FatherRepository _fatherRepository;

  Future<void> loadDropdowns() async {
    emit(FatherLoading());

    final result = await getNationalitiesAndCities(PersonType.father);

    result.when(
      success: (data) {
        emit(FatherDropdownsLoaded(
          nationalities: data.nationalities,
          cities: data.cities,
        ));
      },
      failure: (error) => emit(FatherError(error.message)),
    );
  }

  Future<void> loadAreas(String cityName) async {
    emit(FatherLoading());

    final result = await loadAreasByCityId(PersonType.father, cityName);

    result.when(
      success: (data) => emit(FatherAreasLoaded(data)),
      failure: (error) => emit(FatherError(error.message)),
    );
  }

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
    // مثال: gender في الـ model بالعربية "أنثى" أو "ذكر"، هنا نحتاج تحويلها لقيمة رقمية أو "male"/"female"
    if (model.gender != null) {
      selectedGender = (model.gender == 'ذكر') ? 'male' : 'female';
    } else {
      selectedGender = null;
    }
    selectedNationalityId = model.nationalitiesId;
    selectedAreaId = model.locationId;
    phoneController.text = model.phoneNumber ?? '';
    emailController.text = model.email ?? '';
  }

  Future<void> searchFather(String identity) async {
    emit(FatherLoading());

    final result =
        await personRepository.searchPersonById( identity, PersonType.father);

    result.when(
      success: (res) {
        if (res == null) {
          emit(FatherNotFound());
          return;
        }
        if (res.father != null) {
          fillFormWithFather(res.father!);
          emit(FatherFound(isFullFather: true));
        } else if (res.person != null) {
          fillFormWithPerson(res.person!);
          emit(FatherFound(isFullFather: false));
        } else {
          emit(FatherNotFound());
        }
      },
      failure: (error) => emit(FatherError(error.message)),
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
  Future<void> toggleFatherActivation(String id, bool activate) async {
    emit(FatherLoading());

    final result = await personRepository.toggleActivation(
        PersonType.father, id, activate);

    result.when(
      success: (_) => emit(FatherToggleActivationSuccess()),
      failure: (error) => emit(FatherError(error.message)),
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

  void setGender(String value) {
    selectedGender = value;
    emit(FatherInitial());
  }

  void setIsDead(bool value) {
    isDead = value;
    emit(FatherInitial());
  }

  @override
  void emitCurrentState() {
    // TODO: implement emitCurrentState
  }
}
