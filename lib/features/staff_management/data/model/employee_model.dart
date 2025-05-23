import 'package:new_project/features/personal_management/data/models/person_model.dart';

class EmployeeModel {
  static int _tempIdCounter = 0;
  final int id;
  final DateTime employmentDate;
  final DateTime dateOfBirth;
  final int healthCenterId;
  final bool isActive;
  final PersonModel? personData;

  EmployeeModel({
    int? id,
    required this.employmentDate,
    required this.dateOfBirth,
    required this.healthCenterId,
    this.isActive = true,
    this.personData,
  }) : id = id ?? _tempIdCounter++;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      employmentDate: DateTime.parse(json['employment_date']),
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      healthCenterId: json['health_center_id'],
      isActive: json['is_active'] ?? true,
      personData:
          json['person'] != null ? PersonModel.fromJson(json['person']) : null,
    );
  }

  get nationalityId => null;

  Map<String, dynamic> toJson({bool isPersonExist = false}) {
    if (isPersonExist && personData != null) {
      return {
        'isPersonExist': true,
        'personId': personData!.id,
        'employment_date': employmentDate.toIso8601String(),
        'date_of_birth': dateOfBirth.toIso8601String(),
        'health_center_id': healthCenterId,
        'is_active': isActive,
      };
    } else {
      return {
       
      };
    }
  }

 

  EmployeeModel copyWith({
    int? id,
    DateTime? employmentDate,
    DateTime? dateOfBirth,
    String? healthCenterId,
    bool? isActive,
    PersonModel? personData,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      employmentDate: employmentDate ?? this.employmentDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isActive: isActive ?? this.isActive,
      personData: personData ?? this.personData,
      healthCenterId: healthCenterId != null
          ? int.parse(healthCenterId)
          : this.healthCenterId,
    );
  }
}
