import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/dropdown_helper/dropdown_storage_helper.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/common_dropdowns_response.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';
import 'package:new_project/features/personal_management/logic/personal_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final PersonRepository _personRepository;
  List<CommonDropDownsResponse> nationalities = [];
  List<CommonDropDownsResponse> cities = [];
  PersonModel? personModel;

  PersonCubit(this._personRepository) : super(PersonInitial());

  Future<void> searchPersonById(PersonType type, String id) async {
    emit(PersonLoading());
    final result = await _personRepository.searchPersonById(type, id);
    result.when(
      success: (data) => emit(PersonSearchSuccess(data)),
      failure: (error) => emit(PersonFailure((error.message))),
    );
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
    emit(PersonLoading());

    //  قراءة البيانات من التخزين المحلي
    final cachedData = await DropdownStorageHelper.getDropdownsData();

    if (cachedData != null) {
      emit(PersonNationalitiesAndCitiesLoaded(
        cachedData.nationalities,
        cachedData.cities,
      ));
      return;
    }

    // في حال ما وُجدت، حملها من الـ API
    final result = await _personRepository.getNationalitiesAndCities(type);
    result.when(
      success: (data) async {
        // خزّن البيانات في SharedPreferences
        await DropdownStorageHelper.saveDropdownsData(
          CommonDropDownsResponse(
            nationalities: data.$1,
            cities: data.$2,
          ),
        );
        emit(PersonNationalitiesAndCitiesLoaded(data.$1, data.$2));
      },
      failure: (error) {
        emit(PersonFailure((error.message)));
      },
    );
  }

  List<AreaModel> _areas = [];

  List<AreaModel> get filteredAreas => _areas;

  Future<void> loadAreasByCityId(PersonType type, String cityName) async {
    emit(PersonLoading());

    final result = await _personRepository.getAreasByCity(type, cityName);

    result.when(
      success: (data) {
        _areas = data;
        emit(PersonAreasLoaded(data));
      },
      failure: (error) {
        emit(PersonFailure((error.message)));
      },
    );
  }
}
