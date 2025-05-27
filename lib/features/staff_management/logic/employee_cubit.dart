import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/data/repo/PersonHelperMixin.dart';
import 'package:new_project/features/staff_management/data/model/HealthCenterModel.dart';
import 'package:new_project/features/staff_management/data/model/Role.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/domain/repository/employeeRepository.dart';
import 'package:new_project/features/staff_management/logic/employee.state.dart';
import '../../personal_management/data/models/area_model.dart';
import '../../personal_management/domain/repositories/personal_repo.dart';

class EmployeeCubit extends Cubit<EmployeeState> with PersonHelperMixin {
  EmployeeCubit(this._EmployeeRepository, PersonRepository personRepo)
      : super(EmployeeInitial()) {
    print("EmployeeCubit created ✅");
    setRepository(personRepo);
  }

  final EmployeeRepository _EmployeeRepository;
  // ========== Controllers ==========
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final identityController = TextEditingController();
  final birthDateController = TextEditingController();
  final employmentDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // ========== State variables ==========
  String? selectedGender;
  int? selectedNationalityId;
  int? selectedHealthCenterId;
  String? selectedRole;
  int? isActive = 1;
  bool isDead = false;
  String? selectedCity;
  int? selectedCityId;
  String? selectedArea;
  int? selectedAreaId;
// إضافة هذه المتغيرات في EmployeeCubit
  List<Role> roles = [];
  List<HealthCenterModel> healthCenters = [];
  // ========== Setters ==========
  void setGender(String value) {
    selectedGender = value;
    emit(EmployeeFormDataLoaded());
  }

  void setIsActive(int value) {
    isActive = value;
    emit(EmployeeFormDataLoaded());
  }

  void setIsDead(bool value) {
    isDead = value;
    emit(EmployeeFormDataLoaded());
  }

  @override
  Future<void> setCity(String? cityName, {int? autoSelectAreaId}) async {
    emit(EmployeeLoaded());
    final city = cities.firstWhereOrNull((c) => c.city_name == cityName);
    if (city == null) {
      emit(EmployeeLoaded());
      return;
    }

    selectedCity = city.city_name;
    await loadAreas(city.city_name);

    if (autoSelectAreaId != null) {
      final area = areas.firstWhereOrNull((a) => a.id == autoSelectAreaId);
      if (area != null) {
        selectedArea = area.area_name;
        selectedAreaId = area.id;
      }
    }
    emit(EmployeeDropdownsLoaded());
  }

  @override
  void setArea(int? areaId) {
    if (areaId == null) return;

    print('🔎 محاولة تعيين المنطقة ID: $areaId');
    print('المناطق المتاحة حالياً:');
    areas.forEach((a) => print('- ${a.id}: ${a.area_name}'));

    final area = areas.firstWhereOrNull((a) => a.id == areaId);
    if (area != null) {
      selectedArea = area.area_name;
      selectedAreaId = area.id;
      print('✅ تم تعيين المنطقة بنجاح: ${area.area_name}');
    } else {
      print('❌ فشل في تعيين المنطقة (ID: $areaId)');
    }
    emit(EmployeeFormDataLoaded());
  }

  // ========== Form Prefill ==========
  void fillFormFromPerson(SearchPersonResponse response) async {
    final person = response.data?.person;
    print('\n=== بدء تعبئة النموذج من بيانات الشخص ===');

    if (person != null) {
      //await loadCachedData();
      // تعبئة البيانات الأساسية أولاً
      firstNameController.text = person.first_name;
      lastNameController.text = person.last_name;
      emailController.text = person.email ?? '';
      birthDateController.text =
          DateFormat('yyyy-MM-dd').format(person.birthDate ?? DateTime.now());
      phoneController.text = person.phone_number ?? '';
      identityController.text = person.identity_card_number;
      setGender(person.gender);
      selectedNationalityId = person.nationalities_id;

      // تعبئة الموقع (المدينة والمنطقة)
      if (person.location != null && person.location_id != null) {
        print('==== بيانات الموقع ====');
        print('location_id من الشخص: ${person.location_id}');
        print('بيانات location: ${person.location}');

        await setCity(
          person.location!.city_name ?? person.location!.area_name,
          autoSelectAreaId: person
              .location_id, // نستخدم location_id بدلاً من person.location!.id
        );

        await Future.delayed(const Duration(milliseconds: 100));

        // التحقق من وجود المنطقة باستخدام location_id
        if (areas.any((a) => a.id == person.location_id)) {
          setArea(person.location_id);
        } else {
          print('لم يتم العثور على المنطقة المطابقة لـ location_id');
        }
      }
      emit(EmployeeFormDataLoaded());
    } else {
      clearForm();
    }
  }

  // ========== Form Employee ==========
  void fillFormFromEmployee(SearchPersonResponse response) async {
    final Employee = response.data?.employee;
    print('====== fillFormFromEmployee called ======');
    print(
        'Employee data: ${Employee?.first_name}, ${Employee?.last_name}, ID: ${Employee?.id}');
    if (Employee != null) {
      print(' [4.1] تم العثور على بيانات الموظف');
      firstNameController.text = Employee.first_name;
      lastNameController.text = Employee.last_name;
      emailController.text = Employee.email ?? '';
      birthDateController.text =
          DateFormat('yyyy-MM-dd').format(Employee.birthDate ?? DateTime.now());
      phoneController.text = Employee.phone_number ?? '';
      identityController.text = Employee.identity_card_number;
      setGender(Employee.gender);
      isActive = Employee.isActive;
      isDead = Employee.isDeceased;
      selectedRole = Employee.role;
      selectedHealthCenterId = Employee.health_center_id;
      selectedNationalityId = Employee.nationalities_id;

      if (Employee.location != null) {
        // المدينة بالاسم، والحي بالـ ID
        await setCity(
          Employee.location!.city_name ?? '',
          autoSelectAreaId: Employee.location!.id,
        );
      }
      emit(EmployeeFormDataLoaded());
      print('=== انتهت تعبئة النموذج بنجاح ===\n');
    } else {
      clearForm();
    }
  }

  // ========== Clear Form ==========
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    identityController.clear();
    birthDateController.clear();
    phoneController.clear();
    emailController.clear();

    selectedGender = null;
    selectedNationalityId = null;
    selectedCity = null;
    selectedCityId = null;
    selectedArea = null;
    selectedAreaId = null;
    isDead = false;
    isActive = null;

    emit(EmployeeInitial());
  }

  Future<void> fetchEmployeeByIdentity(String identity) async {
    emit(EmployeeLoaded());

    final result =
        await personRepository.searchPersonById(identity, PersonType.employee);

    result.when(
      success: (response) async {
        if (response?.data == null) {
          clearForm(); // تنظيف الفورم
          emit(EmployeeNotFound()); // إرسال حالة عدم العثور
          return;
        }

        final data = response!.data!;

        if (data.employee != null) {
          fillFormFromEmployee(response);
          emit(EmployeeDataFound(data.employee!));
        } else if (data.person != null) {
          fillFormFromPerson(response);
          emit(EmployeePersonFound(data.person!));
        } else {
          clearForm(); // تنظيف الفورم
          emit(EmployeeNotFound()); // إرسال حالة عدم العثور
        }
      },
      failure: (error) {
        clearForm(); // تنظيف الفورم في حالة الخطأ
        emit(EmployeeError(error.message));
      },
    );
  }

  Future<void> submitEmployee(BuildContext context,
      {String? EmployeeId}) async {
    try {
      final isDeceasedInt = isDead ? 1 : 0;
      final isActiveInt = isActive ?? 0;

      final model = EmployeeModel(
        first_name: firstNameController.text,
        last_name: lastNameController.text,
        identity_card_number: identityController.text,
        date_of_birth: birthDateController.text.isNotEmpty
            ? DateTime.parse(birthDateController.text)
            : null,
        phone_number: phoneController.text,
        email: emailController.text,
        nationalities_id: selectedNationalityId ?? 1,
        location_id: selectedCityId ?? 1,
        role: selectedRole ?? 'employee',
        isActive: isActive ?? 0,
        health_center_id: selectedHealthCenterId,
        gender: selectedGender ?? 'ذكر',
        employment_date: employmentDateController.text.isNotEmpty
            ? DateTime.parse(employmentDateController.text)
            : null,
      );

      if (EmployeeId != null) {
        await updateEmployee(EmployeeId, model);
      } else {
        await addEmployee(model);
      }

      Navigator.pop(context);
    } catch (e) {
      emit(EmployeeError(' تم ارسال البيانات'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم ارسال البيانات: ')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> addEmployee(EmployeeModel model) async {
    emit(const EmployeeLoaded());
    final result = await _EmployeeRepository.addEmployee(model);
    result.when(
      success: (_) => emit(EmployeeAddSuccess()),
      failure: (error) => emit(EmployeeError(error.message)),
    );
  }

  Future<void> updateEmployee(String id, EmployeeModel model) async {
    emit(const EmployeeLoaded());
    final result = await _EmployeeRepository.updateEmployee(id, model);
    result.when(
      success: (_) => emit(EmployeeUpdateSuccess()),
      failure: (error) => emit(EmployeeError(error.message)),
    );
  }

  Future<void> toggleEmployeeActivation(String id, bool activate) async {
    emit(const EmployeeLoaded());
    final result = await personRepository.toggleActivation(
        PersonType.employee, id, activate);
    result.when(
      success: (_) => emit(EmployeeToggleActivationSuccess()),
      failure: (error) => emit(EmployeeError(error.message)),
    );
  }

  Future<void> loadCreateEmployeeData() async {
    emit(EmployeeLoading());

    final result = await _EmployeeRepository.fetchCreateEmployeeData();

    result.when(
      success: (data) {
        roles = data.roles;
        healthCenters = data.healthCenters;
        emit(EmployeeFormDataLoaded()); // حالة جديدة تبين إن القوائم جاهزة
      },
      failure: (error) {
        emit(EmployeeError(error.message));
      },
    );
  }

  // ========== Dropdowns ==========
  Future<void> loadDropdowns() async {
    emit(const EmployeeLoaded());
    print('🔄 جاري تحميل القوائم المنسدلة (الجنسيات والمدن)...');

    final result = await getNationalitiesAndCities(PersonType.employee);
    result.when(
      success: (data) {
        print('✅ تم تحميل ${data.nationalities.length} جنسية');
        print('✅ تم تحميل ${data.cities.length} مدينة');

        // تأكد من تحديث قائمة cities في الميكسين
        this.cities = data.cities;

        emit(EmployeeDropdownsLoaded(
          nationalities: data.nationalities,
          cities: data.cities,
        ));
      },
      failure: (error) {
        print('❌ فشل تحميل القوائم المنسدلة: ${error.message}');
        emit(EmployeeError(error.message));
      },
    );
  }

  // في Employee_cubit.dart
  Future<void> loadAreas(String cityId) async {
    if (cityId.isEmpty) return;
    emit(EmployeeLoaded());

    final result =
        await personRepository.getAreasByCity(PersonType.employee, cityId);

    result.when(
      success: (areas) {
        this.areas =
            areas.map((areaMap) => AreaModel.fromJson(areaMap)).toList();
        emit(EmployeeAreasLoaded(
          this.areas,
        ));
      },
      failure: (error) => emit(EmployeeError(error.message)),
    );
  }

  void printFormState() {
    print('\n📋 حالة النموذج الحالية:');
    print('- الاسم الأول: ${firstNameController.text}');
    print('- الاسم الأخير: ${lastNameController.text}');
    print('- الهوية: ${identityController.text}');
    print('- الهاتف: ${phoneController.text}');
    print('- البريد: ${emailController.text}');
    print('- تاريخ الميلاد: ${birthDateController.text}');
    print('- الجنس: $selectedGender');
    print('- الجنسية ID: $selectedNationalityId');
    print('- المدينة: $selectedCity (ID: $selectedCityId)');
    print('- المنطقة: $selectedArea (ID: $selectedAreaId)');
    print('- الحالة: $isActive');
    print('- متوفى: $isDead');
    print('\n');
  }
}
