import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/dropdown_helper/dropdown_storage_helper.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/nationalitiesAndcities_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';
import 'package:new_project/features/personal_management/logic/personal_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final PersonRepository _personRepository;
  List<NationalitiesAndCitiesModel> nationalities = [];
  List<NationalitiesAndCitiesModel> cities = [];
  PersonModel? personModel;

  PersonCubit(this._personRepository) : super(PersonInitial());

Future<void> searchPersonById(String id, PersonType type) async {
  print('\n🚀 ======= بدء عملية البحث الكاملة =======');
  print('⏳ [4] جاري إعداد حالة التحميل في الـ Cubit');
  emit(PersonLoading());

  print('🔎 [5] جاري استدعاء Repository للبحث');
  final result = await _personRepository.searchPersonById(id, type);

  result.when(
    success: (data) {
      print('🎉 [6] عملية البحث نجحت');
      print('📦 البيانات المستلمة: ${data}');
      
      if (data?.data?.person == null) {
        print('⚠️ [6.1] لا يوجد بيانات شخص في النتيجة');
      } else if (data?.data?.father == null) {
        print('ℹ️ [6.2] تم العثور على بيانات الشخص فقط');
      } else {
        print('✅ [6.3] تم العثور على بيانات الأب كاملة');
      }
      
      emit(PersonSearchSuccess(data));
    },
    failure: (error) {
      print('💥 [6] فشل عملية البحث: ${error.message}');
      print('🛠 نوع الخطأ: ${error.runtimeType}');
      emit(PersonFailure(error.message));
    },
  );
  
  print('🏁 ======= انتهت عملية البحث =======\n');
}



  Future<void> toggleActivation(
      PersonType type, String id, bool isActive) async {
    emit(PersonLoading());
    final result = await _personRepository.toggleActivation(type, id, isActive);
    result.when(
      success: (_) => emit(PersonToggleActivationSuccess()),
      failure: (error) => emit(PersonFailure((error.message))),
    );
  }

  Future<void> getNationalitiesAndCities(PersonType type) async {
    print('🚀 [1] بدء تحميل الجنسيات والمدن');
    emit(PersonLoading());
    print('🔄 [2] محاولة تحميل البيانات من التخزين المؤقت');

    final cachedData = await DropdownStorageHelper.getDropdownsData();

    print('✅ [3] تم استلام البيانات من التخزين المؤقت');

    if (cachedData != null) {
      print('📦 [3.1] البيانات المخزنة: ${cachedData.toJson()}');
      emit(PersonNationalitiesAndCitiesLoaded(
        cachedData.nationalities,
        cachedData.cities,
      ));
      print('✅ [3.2] تم تحميل البيانات من التخزين المؤقت');
      return;
    }

    // في حال ما وُجدت، حملها من الـ API
    final result = await _personRepository.getNationalitiesAndCities(type);
    print('🔍 Result from repository: $result');

    print('🔄 [4] محاولة تحميل البيانات من الـ API');
    result.when(
      success: (data) async {
        print('✅ [5] تم تحميل البيانات بنجاح');
        // خزّن البيانات في SharedPreferences
        await DropdownStorageHelper.saveDropdownsData(

          NationalitiesAndCitiesModel(
            nationalities: data.$1,
            cities: data.$2,
          ),
        );
        print('💾 [5.1] تم تخزين البيانات في SharedPreferences');
        emit(PersonNationalitiesAndCitiesLoaded(data.$1, data.$2));
      },
      failure: (error) {
        print('💥 [5] فشل تحميل البيانات: ${error.message}');
        emit(PersonFailure((error.message)));
      },
    );
  }

  List<AreaModel> _areas = [];

  List<AreaModel> get filteredAreas => _areas;

  Future<void> loadAreasByCityId(PersonType type, String cityName) async {
    print('🚀 [1] بدء تحميل المناطق حسب المدينة');
    emit(PersonLoading());
    print('🔄 [2] محاولة تحميل المناطق من الـ API');
    final result = await _personRepository.getAreasByCity(type, cityName);
    print('🔄 [3] محاولة تحميل المناطق من الـ API');
    print('🔍 Result from repository: $result');

    result.when(
      success: (data) {
        print('✅ [4] تم تحميل المناطق بنجاح');
        _areas = data;
        emit(PersonAreasLoaded(data));
      },
      failure: (error) {
        print('💥 [4] فشل تحميل المناطق: ${error.message}');
        emit(PersonFailure((error.message)));
      },
    );
  }
}
