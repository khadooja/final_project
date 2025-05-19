import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class SearchPersonResponse {
  final PersonModel person;

  final FatherModel? father;
  final MotherModel? mother;
  final EmployeeModel? employee;
  final GurdianModel? guardian;

  SearchPersonResponse({
    required this.person,
    this.father,
    this.mother,
    this.employee,
    this.guardian,
  });

  factory SearchPersonResponse.fromJson(
    Map<String, dynamic> json,
    PersonType personType,
  ) {
    final data = json['data'];
    return SearchPersonResponse(
      person: PersonModel.fromJson(data['person']),
      father: personType == PersonType.father && data['father'] != null
          ? FatherModel.fromJson(data['father'])
          : null,
      mother: personType == PersonType.mother && data['mother'] != null
          ? MotherModel.fromJson(data['mother'])
          : null,
      employee: personType == PersonType.employee && data['employee'] != null
          ? EmployeeModel.fromJson(data['employee'])
          : null,
      guardian: personType == PersonType.guardian && data['guardian'] != null
          ? GurdianModel.fromJson(data['guardian'])
          : null
    );
  
  }
}
