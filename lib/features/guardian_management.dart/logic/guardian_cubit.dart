import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/guardian_repository.dart';
import 'package:new_project/features/guardian_management.dart/logic/guardian_state.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import '../../personal_management/domain/repositories/personal_repo.dart';

class GuardianCubit extends Cubit<GuardianState> {
  final GuardianRepository _guardianRepository;
  final PersonRepository _personRepository;
  final ChildGuardianRepository _childGuardianRepository;

  GuardianCubit(this._guardianRepository, this._personRepository,
      this._childGuardianRepository)
      : super(GuardianInitial());

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final identityController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final guardianIdController = TextEditingController();
  String? selectedRelationshipTypeId;
  String? childId;

  // Dropdown selections
  String? selectedGender;
  int? selectedNationalityId;
  int? selectedCityId;
  int? selectedAreaId;

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    identityController.clear();
    birthDateController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    guardianIdController.clear();
    selectedGender = null;
    selectedNationalityId = null;
    selectedCityId = null;
    selectedAreaId = null;
    selectedRelationshipTypeId = null;
    childId = null;
  }

  void fillFormWithGuardian(GurdianModel model) {
    firstNameController.text = model.firstName;
    lastNameController.text = model.lastName;
    identityController.text = model.identityCardNumber;
    birthDateController.text = model.birthDate?.toString() ?? '';
    phoneController.text = model.phoneNumber ?? '';
    emailController.text = model.email ?? '';
    selectedGender = model.gender;
    selectedNationalityId = model.nationalitiesId;
    selectedAreaId = model.locationId;
  }

  void fillFormWithPerson(PersonModel model) {
    firstNameController.text = model.firstName;
    lastNameController.text = model.lastName;
    identityController.text = model.identityCardNumber;
    selectedGender = model.gender;
    selectedNationalityId = model.nationalitiesId;
    selectedAreaId = model.locationId;
  }

  // Search for guardian by identity
  Future<void> searchByIdentity(PersonType type, String identity) async {
    emit(GuardianLoading());

    final result = await _personRepository.searchPersonById(type, identity);

    result.when(
      success: (person) {
        if (person is GurdianModel) {
          fillFormWithGuardian(person);
          emit(GuardianFound(isFullGuardian: true));
        } else if (person is PersonModel) {
          fillFormWithPerson(person);
          emit(GuardianFound(isFullGuardian: false));
        } else {
          clearForm();
          emit(GuardianNotFound());
        }
      },
      failure: (error) {
        clearForm();
        emit(GuardianFailure("فشل البحث: ${error.message}"));
      },
    );
  }

  // Add a new guardian
  Future<void> addGuardian(GurdianModel model) async {
    emit(GuardianLoading());
    final result = await _guardianRepository.addGuardian(model);

    result.when(
      success: (_) => emit(GuardianAddSuccess()),
      failure: (error) {
        emit(GuardianFailure((error.message)));
      },
    );
  }

  // Update an existing guardian's information
  Future<void> updateGuardian(String id, GurdianModel model) async {
    emit(GuardianLoading());
    final result = await _guardianRepository.updateGuardian(id, model);

    result.when(
      success: (_) => emit(GuardianUpdateSuccess()),
      failure: (error) {
        emit(GuardianFailure(error.message));
      },
    );
  }

  // Toggle the activation status of the guardian
  Future<void> toggleActivation(String id) async {
    emit(GuardianLoading());
    final result =
        await _personRepository.toggleActivation(PersonType.guardian, id, true);

    result.when(
      success: (_) => emit(GuardianToggleActivationSuccess()),
      failure: (error) {
        emit(GuardianFailure((error.message)));
      },
    );
  }

  Future<void> submitGuardian({
    String? childId, // أصبح اختياري الآن
    String? guardianId, // إذا موجود يعني الكفيل موجود مسبقًا
  }) async {
    emit(GuardianLoading());

    // إذا كان guardianId موجوداً (ولي أمر موجود) و childId غير موجود
    if (guardianId != null && childId == null) {
      emit(GuardianFailure("يجب تحديد الطفل لربط ولي الأمر"));
      return;
    }

    // إذا كان ولي الأمر موجوداً وسيتم ربطه بطفل
    if (guardianId != null && childId != null) {
      if (selectedRelationshipTypeId == null) {
        emit(GuardianFailure("الرجاء اختيار نوع العلاقة"));
        return;
      }

      final result = await _childGuardianRepository.linkGuardianToChild(
        guardianId,
        childId,
        selectedRelationshipTypeId!,
      );

      result.when(
        success: (_) => emit(GuardianLinkSuccess()),
        failure: (error) => emit(GuardianFailure((error.message))),
      );
      return;
    }

    // إذا كان ولي أمر جديد (سواء مع أو بدون childId)
    final guardianModel = GurdianModel(
      id: guardianId != null ? int.parse(guardianId) : 0,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      identityCardNumber: identityController.text,
      birthDate: DateTime.parse(birthDateController.text),
      phoneNumber: phoneController.text,
      email: emailController.text,
      nationalitiesId: selectedNationalityId ?? 0,
      locationId: selectedAreaId ?? 0,
      isActive: true,
      gender: selectedGender ?? 'male',
    );

    final addResult = await _guardianRepository.addGuardian(guardianModel);

    addResult.when(
      success: (guardianResponse) async {
        final newGuardianId = guardianResponse.id.toString();

        // إذا كان هناك childId، نقوم بعملية الربط
        if (childId != null) {
          if (selectedRelationshipTypeId == null) {
            emit(GuardianFailure("الرجاء اختيار نوع العلاقة"));
            return;
          }

          final linkResult = await _childGuardianRepository.linkGuardianToChild(
            newGuardianId,
            childId,
            selectedRelationshipTypeId!,
          );

          linkResult.when(
            success: (_) => emit(GuardianLinkSuccess()),
            failure: (error) => emit(GuardianFailure(
              (error.message),
            )),
          );
        } else {
          // إذا لم يكن هناك childId، نكتفي بإضافة ولي الأمر
          emit(GuardianAddSuccess());
        }
      },
      failure: (error) => emit(GuardianFailure(
        (error.message),
      )),
    );
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    identityController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    guardianIdController.dispose();
    return super.close();
  }
}
