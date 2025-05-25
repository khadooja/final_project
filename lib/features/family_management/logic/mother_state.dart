import 'package:equatable/equatable.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';

import 'package:new_project/features/personal_management/data/models/SimpleNationalityModel.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

abstract class MotherState extends Equatable {
  const MotherState();

  @override
  List<Object?> get props => [];
}

// الحالة الابتدائية
class MotherInitial extends MotherState {}

// حالة التحميل
//class FatherLoading extends FatherState {}
class MotherLoaded extends MotherState {
  final SearchPersonResponse? searchResult;
  final MotherModel? mother;

  const MotherLoaded({this.searchResult, this.mother});

  MotherLoaded copyWith({
    SearchPersonResponse? searchResult,
    MotherModel? mother,
  }) {
    return MotherLoaded(
      searchResult: searchResult ?? this.searchResult,
      mother: mother ?? this.mother,
    );
  }
}

class MotherFormDataLoaded extends MotherState {}

class MotherDataFound extends MotherState {
  final MotherModel mother;
  const MotherDataFound(this.mother);
}

class MotherPersonFound extends MotherState {
  final PersonModel person;
  const MotherPersonFound(this.person);
}

class MotherSuccess extends MotherState {}

// حالة تحميل القوائم المنسدلة
class MotherDropdownsLoaded extends MotherState {
  final List<SimpleNationalityModel> nationalities;
  final List<CityModel> cities;

  const MotherDropdownsLoaded(
      {this.nationalities = const [], this.cities = const []});

  // List<Object?> get props => [nationalities, cities];
}

// حالة تحميل الأحياء بعد اختيار المدينة
class MotherAreasLoaded extends MotherState {
  final List<AreaModel> areas;

  const MotherAreasLoaded(this.areas);

  @override
  List<Object?> get props => [areas];
}

// حالة البحث وعرض نتائج الشخص (بحث بالهوية)
class MotherSearchResultLoaded extends MotherState {
  final SearchPersonResponse result;

  const MotherSearchResultLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class MotherPersonOnlyLoaded extends MotherState {
  final PersonModel person;

  const MotherPersonOnlyLoaded(this.person);
}

// حالة الشخص موجود فقط
class PersonFoundState extends MotherState {
  final PersonModel person;

  const PersonFoundState(this.person);

  @override
  List<Object?> get props => [person];
}

// حالة الأب موجود بكامل بياناته
class FullMotherFoundState extends MotherState {
  final MotherModel mother;

  const FullMotherFoundState(this.mother);

  @override
  List<Object?> get props => [mother];
}

// حالة الأب غير موجود
class MotherNotFound extends MotherState {}

// تم إضافة أو تحديث الأب بنجاح
class MotherAddSuccess extends MotherState {}

class MotherUpdateSuccess extends MotherState {}

// تفعيل / تعطيل الأب
class MotherToggleActivationSuccess extends MotherState {}

// حالة نجاح البحث
class MotherSearchSuccess extends MotherState {
  final MotherModel mother;

  const MotherSearchSuccess(this.mother);

  @override
  List<Object?> get props => [mother];
}

// حالة الخطأ
class MotherError extends MotherState {
  final String message;

  const MotherError(this.message);

  @override
  List<Object?> get props => [message];
}
