import 'package:equatable/equatable.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/personal_management/data/models/SimpleNationalityModel.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

abstract class FatherState extends Equatable {
  const FatherState();

  @override
  List<Object?> get props => [];
}

// الحالة الابتدائية
class FatherInitial extends FatherState {}

// حالة التحميل
//class FatherLoading extends FatherState {}
class FatherLoaded extends FatherState {
  final SearchPersonResponse? searchResult;
  final FatherModel? father;

  const FatherLoaded({this.searchResult, this.father});

  FatherLoaded copyWith({
    SearchPersonResponse? searchResult,
    FatherModel? father,
  }) {
    return FatherLoaded(
      searchResult: searchResult ?? this.searchResult,
      father: father ?? this.father,
    );
  }
}

class FatherFormDataLoaded extends FatherState {}

class FatherDataFound extends FatherState {
  final FatherModel father;
  const FatherDataFound(this.father);
}

class FatherPersonFound extends FatherState {
  final PersonModel person;
  const FatherPersonFound(this.person);
}
class FatherSuccess extends FatherState {
}
// حالة تحميل القوائم المنسدلة
class FatherDropdownsLoaded extends FatherState {
  final List<SimpleNationalityModel> nationalities;
  final List<CityModel> cities;

  const FatherDropdownsLoaded({this.nationalities = const [],this.cities = const [] }
    );


 // List<Object?> get props => [nationalities, cities];
}

// حالة تحميل الأحياء بعد اختيار المدينة
class FatherAreasLoaded extends FatherState {
  final List<AreaModel> areas;

  const FatherAreasLoaded(this.areas);

  @override
  List<Object?> get props => [areas];
}

// حالة البحث وعرض نتائج الشخص (بحث بالهوية)
class FatherSearchResultLoaded extends FatherState {
  final SearchPersonResponse result;

  const FatherSearchResultLoaded(this.result);

  @override
  List<Object?> get props => [result];
}
class FatherPersonOnlyLoaded extends FatherState {
  final PersonModel person;

  const FatherPersonOnlyLoaded(this.person);
}


// حالة الشخص موجود فقط
class PersonFoundState extends FatherState {
  final PersonModel person;

  const PersonFoundState(this.person);

  @override
  List<Object?> get props => [person];
}

// حالة الأب موجود بكامل بياناته
class FullFatherFoundState extends FatherState {
  final FatherModel father;

  const FullFatherFoundState(this.father);

  @override
  List<Object?> get props => [father];
}

// حالة الأب غير موجود
class FatherNotFound extends FatherState {}

// تم إضافة أو تحديث الأب بنجاح
class FatherAddSuccess extends FatherState {}

class FatherUpdateSuccess extends FatherState {}

// تفعيل / تعطيل الأب
class FatherToggleActivationSuccess extends FatherState {}

// حالة نجاح البحث
class FatherSearchSuccess extends FatherState {
  final FatherModel father;

  const FatherSearchSuccess(this.father);

  @override
  List<Object?> get props => [father];
}

// حالة الخطأ
class FatherError extends FatherState {
  final String message;

  const FatherError(this.message);

  @override
  List<Object?> get props => [message];
}
