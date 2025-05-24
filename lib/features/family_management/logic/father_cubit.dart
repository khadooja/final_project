import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/data/repo/PersonHelperMixin.dart';
import 'package:new_project/features/staff_management/data/model/dropdownclass.dart';
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
  bool? is_Active;
  int? selectedNationalityId;
  bool isDead = false;
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

  void setIsActive(bool value) {
    is_Active = value;
    emit(FatherFormDataLoaded());
  }

  void setIsDead(bool value) {
    isDead = value;
    emit(FatherFormDataLoaded());
  }

@override
Future<void> setCity(String? cityName, {int? autoSelectAreaId}) async {
  emit( FatherLoaded()); 
  final city = cities.firstWhereOrNull((c) => c.city_name == cityName);
  if (city == null) return;

  selectedCity = city.city_name;

  final result = await loadAreasByCityId(PersonType.father, city.city_name.toString());
  
  result.when(
    success: (areas) {
      this.areas = areas;    
      // تحديد المنطقة إذا كان autoSelectAreaId موجوداً
      if (autoSelectAreaId != null) {
        final area = areas.firstWhereOrNull((a) => a.id == autoSelectAreaId);
        if (area != null) {
          selectedArea = area.area_name;
          selectedAreaId = area.id; // تأكد من تعيين ID المنطقة
          print('✅ تم تحديد المنطقة: ${area.area_name} (ID: ${area.id})');
        } else {
          print('⚠️ المنطقة غير موجودة في القائمة المحملة');
          selectedArea = null;
          selectedAreaId = null;
        }
      }
      emit(FatherFormDataLoaded());
    },
    failure: (error) {
      emit(FatherError(error.message));
    },
  );
}
  @override
  void setArea(int? areaId) {
    print('\n🔄 جاري تعيين المنطقة: $areaId');
    final area = areas.firstWhereOrNull((a) => a.id == areaId);
    selectedArea = area?.area_name;
    selectedAreaId = areaId;
      
  print('المنطقة المحددة: ${area?.area_name}');
  print('ID المنطقة: $areaId');
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
    birthDateController.text = DateFormat('yyyy-MM-dd')
        .format(person.birthDate ?? DateTime.now());
    phoneController.text = person.phone_number ?? '';
    identityController.text = person.identity_card_number;
    setGender(person.gender);
    selectedNationalityId = person.nationalities_id;

    // تعبئة الموقع (المدينة والمنطقة)
    if (person.location != null) {
      print('📍 بيانات الموقع:');
      print('- المدينة: ${person.location!.city_name}');
      print('- منطقة ID: ${person.location!.area_name}');
      
      await setCity(
        person.location!.city_name,
        autoSelectAreaId: person.location!.id,
      );
    }

    emit(FatherFormDataLoaded());
    print('✅ تم تعبئة النموذج بنجاح');
  } else {
    clearForm();
  }
}

 // ========== Form father ==========
  void fillFormFromFather(SearchPersonResponse response) async {
    final father = response.data?.father;
    print('====== fillFormFromFather called ======');
    print('Father data: ${father?.first_name}, ${father?.last_name}, ID: ${father?.id}');
    if (father != null) {
      print(' [4.1] تم العثور على بيانات الأب');
      firstNameController.text = father.first_name;
      lastNameController.text = father.last_name;
      emailController.text = father.email ?? '';
      birthDateController.text = DateFormat('yyyy-MM-dd')
          .format(father.birthDate ?? DateTime.now());
      phoneController.text = father.phone_number ?? '';
      identityController.text = father.identity_card_number;
      setGender(father.gender);
      is_Active = father.is_Active;
      isDead = father.isDeceased ?? false;
      selectedNationalityId = father.nationalities_id;
      counterchlidren.text = father.child_Count.toString();

      if (father.location != null) {
      // المدينة بالاسم، والحي بالـ ID
      await setCity(
        father.location!.city_name ?? '',
        autoSelectAreaId: father.location!.id,
      );
    }emit(FatherFormDataLoaded());
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

  // ========== API Calls ==========
  Future<void> fetchFatherByIdentity(String identity) async {
  print('⏳ [1] بدء عملية البحث عن الأب برقم الهوية: $identity');
  emit(const FatherLoaded());

  print('🔄 [2] جاري استدعاء API للبحث...');
  final result = await personRepository.searchPersonById(identity, PersonType.father);

  result.when(
    success: (response) async {
      print('✅ [3] تم استلام الاستجابة بنجاح من API');
      print('📦 محتوى الاستجابة: $response');

      if (response?.data == null) {
        print('⚠️ [3.1] لا يوجد بيانات في الاستجابة');
        clearForm();
        emit(FatherNotFound());
        return;
      }

      final data = response!.data!;
      final father = data.father;
      final person = data.person;

      if (father != null) {
        print('👨‍👦 [4.1] تم العثور على بيانات الأب');
        fillFormFromFather(response);
        emit(FatherDataFound(father));
      } else if (person != null) {
        print('👤 [4.2] تم العثور على بيانات الشخص فقط');
        fillFormFromPerson(response);
        emit(FatherPersonFound(person));
      } else {
        print('⚠️ [4.3] لا يوجد بيانات شخص أو أب في الاستجابة');
        clearForm();
        emit(FatherNotFound());
      }
    },
    failure: (error) {
      print('❌ [3] فشل في استدعاء API: ${error.message}');
      clearForm();
      emit(FatherError(error.message));
    },
  );
}

  Future<void> submitFather({String? fatherId}) async {
    try {
      final model = FatherModel(
        id: fatherId != null ? int.parse(fatherId) : 0,
        first_name: firstNameController.text,
        last_name: lastNameController.text,
        identity_card_number: identityController.text,
        birthDate: DateTime.parse(birthDateController.text),
        phone_number: phoneController.text,
        email: emailController.text,
        nationalities_id: selectedNationalityId ?? 0,
        location_id: selectedCityId,
        isDeceased: isDead,
        is_Active: is_Active ?? true,
        child_Count: 0,
        gender: selectedGender ?? 'male',
      );

      if (fatherId != null) {
        await updateFather(fatherId, model);
      } else {
        await addFather(model);
      }
    } catch (e) {
      emit(FatherError('فشل في إرسال البيانات: ${e.toString()}'));
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
    final result = await personRepository.toggleActivation(PersonType.father, id, activate);
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

  Future<void> loadAreas(String cityId) async {
    if (cityId.isEmpty) return;
    emit(const FatherLoaded());
    final result = await loadAreasByCityId(PersonType.father, cityId);
    result.when(
      success: (areas) {
        this.areas = areas;
        emit(FatherAreasLoaded(areas));
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
