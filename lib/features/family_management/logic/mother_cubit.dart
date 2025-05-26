import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/family_management/domain/repository/motherRepository.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/family_management/logic/mother_state.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/data/repo/PersonHelperMixin.dart';
import '../../personal_management/data/models/area_model.dart';
import '../../personal_management/domain/repositories/personal_repo.dart';

class MotherCubit extends Cubit<MotherState> with PersonHelperMixin {
  MotherCubit(this._motherRepository, PersonRepository personRepo)
      : super(MotherInitial()) {
    setRepository(personRepo);
  }

  final MotherRepository _motherRepository;

  // ========== Controllers ==========
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final identityController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final counterchlidren = TextEditingController();
  // ========== State variables ==========
  String? selectedGender;
  int? is_Active;
  int? selectedNationalityId;
  bool isDead= false;
  int childCount = 0;
  String? selectedCity;
  int? selectedCityId;
  String? selectedArea;
  int? selectedAreaId;

  // ========== Setters ==========
  void setGender(String value) {
    selectedGender = value;
    emit(MotherFormDataLoaded());
  }

  void setIsActive(int value) {
  is_Active = value ;
  emit(MotherFormDataLoaded());
}


  void setIsDead(bool value) {
    isDead = value;
    emit(MotherFormDataLoaded());
  }

  @override
  Future<void> setCity(String? cityName, {int? autoSelectAreaId}) async {
  emit(MotherLoaded());
  final city = cities.firstWhereOrNull((c) => c.city_name == cityName);
  if (city == null) {
    emit(MotherLoaded());
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
  emit(MotherDropdownsLoaded());
}
void setChildCount(String value) {
  final parsed = int.tryParse(value);
  if (parsed != null) {
    childCount = parsed;
    emit(MotherFormDataLoaded());
  }
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
    emit(MotherFormDataLoaded());
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
      emit(MotherFormDataLoaded());
    } else {
      clearForm();
    }
  }

  // ========== Form father ==========
  void fillFormFromMother(SearchPersonResponse response) async {
    final mother = response.data?.mother;
    print('====== fillFormFromFather called ======');
    print(
        'Father data: ${mother?.first_name}, ${mother?.last_name}, ID: ${mother?.id}');
    if (mother != null) {
      print(' [4.1] الام العثور على بيانات ');
      firstNameController.text = mother.first_name;
      lastNameController.text = mother.last_name;
      emailController.text = mother.email ?? '';
      birthDateController.text =
          DateFormat('yyyy-MM-dd').format(mother.birthDate ?? DateTime.now());
      phoneController.text = mother.phone_number ?? '';
      identityController.text = mother.identity_card_number;
      setGender(mother.gender);
      is_Active = mother.is_Active ;
      isDead = mother.isDeceased ;
      selectedNationalityId = mother.nationalities_id;
      counterchlidren.text = mother.child_count.toString();

      if (mother.location != null) {
        // المدينة بالاسم، والحي بالـ ID
        await setCity(
          mother.location!.city_name ?? '',
          autoSelectAreaId: mother.location!.id,
        );
      }
      emit(MotherFormDataLoaded());
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
    counterchlidren.clear();

    selectedGender = null;
    selectedNationalityId = null;
    selectedCity = null;
    selectedCityId = null;
    selectedArea = null;
    selectedAreaId = null;
    isDead = false;
    is_Active = null;

    emit(MotherInitial());
  }
Future<void> fetchMotherByIdentity(String identity) async {
  emit(MotherLoaded());
  
  final result = await personRepository.searchPersonById(identity, PersonType.father);

  result.when(
    success: (response) async {
      if (response?.data == null) {
        clearForm(); // تنظيف الفورم
        emit(MotherNotFound()); // إرسال حالة عدم العثور
        return;
      }

      final data = response!.data!;
      
      if (data.mother != null) {
        fillFormFromMother(response);
        emit(MotherDataFound(data.mother!));
      } else if (data.person != null) {
        fillFormFromPerson(response);
        emit(MotherPersonFound(data.person!));
      } else {
        clearForm(); // تنظيف الفورم
        emit(MotherNotFound()); // إرسال حالة عدم العثور
      }
    },
    failure: (error) {
      clearForm(); // تنظيف الفورم في حالة الخطأ
      emit(MotherError(error.message));
    },
  );
}

  Future<void> submitMother(BuildContext context, {String? motherId}) async {
  try {
    final isDeceasedInt = isDead ? 1 : 0;
    final isActiveInt = is_Active ?? 0;

    final model = MotherModel(
      first_name: firstNameController.text,
      last_name: lastNameController.text,
      identity_card_number: identityController.text,
      birthDate: birthDateController.text.isNotEmpty 
    ? DateTime.parse(birthDateController.text)
    : null,
      phone_number: phoneController.text,
      email: emailController.text,
      nationalities_id: selectedNationalityId ?? 1,
      location_id: selectedCityId ?? 1,
      isDeceased: isDead,
      is_Active: isActiveInt,
      child_count: childCount ?? 0,
      gender: selectedGender ?? 'ذكر',
    );

    if (motherId != null) {
      await updateMother(motherId, model);
    } else {
      await addMother(model);
    }
    
    Navigator.pushReplacementNamed(context, Routes.addChild);
  } catch (e) {
    emit(MotherError('فشل في إرسال البيانات: ${e.toString()}'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل في إرسال البيانات: ${e.toString()}')),
    );
  }
}
  Future<void> addMother(MotherModel model) async {
    emit(const MotherLoaded());
    final result = await _motherRepository.addMother(model);
    result.when(
      success: (_) => emit(MotherAddSuccess()),
      failure: (error) => emit(MotherError(error.message)),
    );
  }

  Future<void> updateMother(String id, MotherModel model) async {
    emit(const MotherLoaded());
    final result = await _motherRepository.updateMother(id, model);
    result.when(
      success: (_) => emit(MotherUpdateSuccess()),
      failure: (error) => emit(MotherError(error.message)),
    );
  }

  Future<void> toggleMotherActivation(String id, bool activate) async {
    emit(const MotherLoaded());
    final result = await personRepository.toggleActivation(
        PersonType.father, id, activate);
    result.when(
      success: (_) => emit(MotherToggleActivationSuccess()),
      failure: (error) => emit(MotherError(error.message)),
    );
  }

  // ========== Dropdowns ==========
  Future<void> loadDropdowns() async {
    emit(const MotherLoaded());
    print('🔄 جاري تحميل القوائم المنسدلة (الجنسيات والمدن)...');

    final result = await getNationalitiesAndCities(PersonType.mother);
    result.when(
      success: (data) {
        print('✅ تم تحميل ${data.nationalities.length} جنسية');
        print('✅ تم تحميل ${data.cities.length} مدينة');

        // تأكد من تحديث قائمة cities في الميكسين
        this.cities = data.cities;

        emit(MotherDropdownsLoaded(
          nationalities: data.nationalities,
          cities: data.cities,
        ));
      },
      failure: (error) {
        print('❌ فشل تحميل القوائم المنسدلة: ${error.message}');
        emit(MotherError(error.message));
      },
    );
  }

  // في father_cubit.dart
Future<void> loadAreas(String cityId) async {
  if (cityId.isEmpty) return;
  emit(MotherLoaded());
  
  final result = await personRepository.getAreasByCity(PersonType.mother, cityId);
  
  result.when(
    success: (areas) {
      this.areas = areas.map((areaMap) => AreaModel.fromJson(areaMap)).toList();
      emit(MotherAreasLoaded(
        this.areas,
      ));
    },
    failure: (error) => emit(MotherError(error.message)),
  );
}
}
