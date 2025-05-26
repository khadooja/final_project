import 'package:equatable/equatable.dart';
import 'package:new_project/features/personal_management/data/models/SimpleNationalityModel.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/staff_management/data/model/CreateEmployeeDataModel.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

// الحالة الابتدائية
class EmployeeInitial extends EmployeeState {}

// حالة التحميل
//class EmployeeLoading extends EmployeeState {}
class EmployeeLoaded extends EmployeeState {
  final SearchPersonResponse? searchResult;
  final EmployeeModel? Employee;

  const EmployeeLoaded({this.searchResult, this.Employee});

  EmployeeLoaded copyWith({
    SearchPersonResponse? searchResult,
    EmployeeModel? Employee,
  }) {
    return EmployeeLoaded(
      searchResult: searchResult ?? this.searchResult,
      Employee: Employee ?? this.Employee,
    );
  }
}

class EmployeeFormDataLoaded extends EmployeeState {}

class EmployeeDataFound extends EmployeeState {
  final EmployeeModel Employee;
  const EmployeeDataFound(this.Employee);
}

class EmployeePersonFound extends EmployeeState {
  final PersonModel person;
  const EmployeePersonFound(this.person);
}

class EmployeeSuccess extends EmployeeState {}

// حالة تحميل القوائم المنسدلة
class EmployeeDropdownsLoaded extends EmployeeState {
  final List<SimpleNationalityModel> nationalities;
  final List<CityModel> cities;

  const EmployeeDropdownsLoaded(
      {this.nationalities = const [], this.cities = const []});

  // List<Object?> get props => [nationalities, cities];
}

// حالة تحميل الأحياء بعد اختيار المدينة
class EmployeeAreasLoaded extends EmployeeState {
  final List<AreaModel> areas;

  const EmployeeAreasLoaded(this.areas);

  @override
  List<Object?> get props => [areas];
}

// حالة البحث وعرض نتائج الشخص (بحث بالهوية)
class EmployeeSearchResultLoaded extends EmployeeState {
  final SearchPersonResponse result;

  const EmployeeSearchResultLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class EmployeePersonOnlyLoaded extends EmployeeState {
  final PersonModel person;

  const EmployeePersonOnlyLoaded(this.person);
}

// حالة الشخص موجود فقط
class PersonFoundState extends EmployeeState {
  final PersonModel person;

  const PersonFoundState(this.person);

  @override
  List<Object?> get props => [person];
}

class EmployeeCreateDataLoaded extends EmployeeState {
  final CreateEmployeeDataModel data;

  const EmployeeCreateDataLoaded(this.data);
}

class EmployeeLoading extends EmployeeState {}

// حالة الأب موجود بكامل بياناته
class FullEmployeeFoundState extends EmployeeState {
  final EmployeeModel Employee;

  const FullEmployeeFoundState(this.Employee);

  @override
  List<Object?> get props => [Employee];
}

// حالة الأب غير موجود
class EmployeeNotFound extends EmployeeState {}

// تم إضافة أو تحديث الأب بنجاح
class EmployeeAddSuccess extends EmployeeState {}

class EmployeeUpdateSuccess extends EmployeeState {}

// تفعيل / تعطيل الأب
class EmployeeToggleActivationSuccess extends EmployeeState {}

// حالة نجاح البحث
class EmployeeSearchSuccess extends EmployeeState {
  final EmployeeModel Employee;

  const EmployeeSearchSuccess(this.Employee);

  @override
  List<Object?> get props => [Employee];
}

// حالة الخطأ
class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}
