import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/data/repo/PersonHelperMixin.dart';
import 'package:new_project/features/staff_management/data/model/dropdownclass.dart';
import '../../personal_management/data/models/area_model.dart';
import '../../personal_management/domain/repositories/personal_repo.dart';

class FatherCubit extends Cubit<FatherState> with PersonHelperMixin {
  FatherCubit(this._fatherRepository, PersonRepository personRepo)
      : super(FatherInitial()) {
    setRepository(personRepo);
  }

  final FatherRepository _fatherRepository;

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
  List<Location> locations = [];

  // ========== Setters ==========
  void setGender(String value) {
    selectedGender = value;
    emit(FatherFormDataLoaded());
  }

  void setIsActive(int value) {
  is_Active = value ;
  emit(FatherFormDataLoaded());
}


  void setIsDead(bool value) {
    isDead = value;
    emit(FatherFormDataLoaded());
  }

  @override
  Future<void> setCity(String? cityName, {int? autoSelectAreaId}) async {
  emit(FatherLoaded());
  final city = cities.firstWhereOrNull((c) => c.city_name == cityName);
  if (city == null) {
    emit(FatherLoaded());
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
  emit(FatherDropdownsLoaded());
}
void setChildCount(String value) {
  final parsed = int.tryParse(value);
  if (parsed != null) {
    childCount = parsed;
    emit(FatherFormDataLoaded());
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
    emit(FatherFormDataLoaded());
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
      emit(FatherFormDataLoaded());
    } else {
      clearForm();
    }
  }

  // ========== Form father ==========
  void fillFormFromFather(SearchPersonResponse response) async {
    final father = response.data?.father;
    print('====== fillFormFromFather called ======');
    print(
        'Father data: ${father?.first_name}, ${father?.last_name}, ID: ${father?.id}');
    if (father != null) {
      print(' [4.1] تم العثور على بيانات الأب');
      firstNameController.text = father.first_name;
      lastNameController.text = father.last_name;
      emailController.text = father.email ?? '';
      birthDateController.text =
          DateFormat('yyyy-MM-dd').format(father.birthDate ?? DateTime.now());
      phoneController.text = father.phone_number ?? '';
      identityController.text = father.identity_card_number;
      setGender(father.gender);
      is_Active = father.is_Active ;
      isDead = father.isDeceased ;
      selectedNationalityId = father.nationalities_id;
      counterchlidren.text = father.child_count.toString();

      if (father.location != null) {
        // المدينة بالاسم، والحي بالـ ID
        await setCity(
          father.location!.city_name ?? '',
          autoSelectAreaId: father.location!.id,
        );
      }
      emit(FatherFormDataLoaded());
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

    emit(FatherInitial());
  }
Future<void> fetchFatherByIdentity(String identity) async {
  emit(FatherLoaded());
  
  final result = await personRepository.searchPersonById(identity, PersonType.father);

  result.when(
    success: (response) async {
      if (response?.data == null) {
        clearForm(); // تنظيف الفورم
        emit(FatherNotFound()); // إرسال حالة عدم العثور
        return;
      }

      final data = response!.data!;
      
      if (data.father != null) {
        fillFormFromFather(response);
        emit(FatherDataFound(data.father!));
      } else if (data.person != null) {
        fillFormFromPerson(response);
        emit(FatherPersonFound(data.person!));
      } else {
        clearForm(); // تنظيف الفورم
        emit(FatherNotFound()); // إرسال حالة عدم العثور
      }
    },
    failure: (error) {
      clearForm(); // تنظيف الفورم في حالة الخطأ
      emit(FatherError(error.message));
    },
  );
}

  Future<void> submitFather(BuildContext context, {String? fatherId}) async {
  try {
    final isDeceasedInt = isDead ? 1 : 0;
    final isActiveInt = is_Active ?? 0;

    final model = FatherModel(
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

    if (fatherId != null) {
      await updateFather(fatherId, model);
    } else {
      await addFather(model);
    }
    
    Navigator.pushReplacementNamed(context, Routes.addMother);
  } catch (e) {
    emit(FatherError('فشل في إرسال البيانات: ${e.toString()}'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل في إرسال البيانات: ${e.toString()}')),
    );
  }
}
  Future<void> addFather(FatherModel model) async {
    emit(const FatherLoaded());
    final result = await _fatherRepository.addFather(model);
    result.when(
      success: (_) => emit(FatherAddSuccess()),
      failure: (error) => emit(FatherError(error.message)),
    );
  }

  Future<void> updateFather(String id, FatherModel model) async {
    emit(const FatherLoaded());
    final result = await _fatherRepository.updateFather(id, model);
    result.when(
      success: (_) => emit(FatherUpdateSuccess()),
      failure: (error) => emit(FatherError(error.message)),
    );
  }

  Future<void> toggleFatherActivation(String id, bool activate) async {
    emit(const FatherLoaded());
    final result = await personRepository.toggleActivation(
        PersonType.father, id, activate);
    result.when(
      success: (_) => emit(FatherToggleActivationSuccess()),
      failure: (error) => emit(FatherError(error.message)),
    );
  }

  // ========== Dropdowns ==========
  Future<void> loadDropdowns() async {
    emit(const FatherLoaded());
    print('🔄 جاري تحميل القوائم المنسدلة (الجنسيات والمدن)...');

    final result = await getNationalitiesAndCities(PersonType.father);
    result.when(
      success: (data) {
        print('✅ تم تحميل ${data.nationalities.length} جنسية');
        print('✅ تم تحميل ${data.cities.length} مدينة');

        // تأكد من تحديث قائمة cities في الميكسين
        this.cities = data.cities;

        emit(FatherDropdownsLoaded(
          nationalities: data.nationalities,
          cities: data.cities,
        ));
      },
      failure: (error) {
        print('❌ فشل تحميل القوائم المنسدلة: ${error.message}');
        emit(FatherError(error.message));
      },
    );
  }

  // في father_cubit.dart
Future<void> loadAreas(String cityId) async {
  if (cityId.isEmpty) return;
  emit(FatherLoaded());
  
  final result = await personRepository.getAreasByCity(PersonType.father, cityId);
  
  result.when(
    success: (areas) {
      this.areas = areas.map((areaMap) => AreaModel.fromJson(areaMap)).toList();
      emit(FatherAreasLoaded(
        this.areas,
      ));
    },
    failure: (error) => emit(FatherError(error.message)),
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
    print('- الحالة: $is_Active');
    print('- متوفى: $isDead');
    print('\n');
  }
}
