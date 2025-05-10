/*import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/data/model/person_model.dart';
import 'package:new_project/features/staff_management/domain/entities/person.dart';

class EmployeeEntity {
  final int id;
  final DateTime employmentDate;
  final DateTime dateOfBirth;
  final int healthCenterId;
  final PersonEntity? personData;
  final bool isActive;

  EmployeeEntity({
    required this.id,
    required this.employmentDate,
    required this.dateOfBirth,
    required this.healthCenterId,
    required this.isActive,
    this.personData,
  });

  EmployeeEntity copyWith({
    String? id,
    DateTime? employmentDate,
    DateTime? dateOfBirth,
    String? healthCenterId,
    bool? isActive,
    PersonEntity? personData,
  }) {
    return EmployeeEntity(
      id: int.parse(id ?? this.id.toString()),
      employmentDate: employmentDate ?? this.employmentDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      healthCenterId:
          int.parse(healthCenterId ?? this.healthCenterId.toString()),
      isActive: isActive ?? this.isActive,
      personData: personData ?? this.personData,
    );
  }

  EmployeeModel toEmployeeModel() {
    return EmployeeModel(
      id: id,
      employmentDate: employmentDate,
      dateOfBirth: dateOfBirth,
      healthCenterId: healthCenterId,
      isActive: isActive,
      personData:
          personData != null ? PersonModel.fromEntity(personData!) : null,
    );
  }

  static EmployeeEntity fromModel(EmployeeModel firstWhere) {
    return EmployeeEntity(
      id: firstWhere.id,
      employmentDate: firstWhere.employmentDate,
      dateOfBirth: firstWhere.dateOfBirth,
      healthCenterId: firstWhere.healthCenterId,
      isActive: firstWhere.isActive,
      personData: firstWhere.personData != null
          ? PersonEntity.fromModel(firstWhere.personData!)
          : null,
    );
  }

  EmployeeModel toEntity() {
    return EmployeeModel(
      id: id,
      employmentDate: employmentDate,
      dateOfBirth: dateOfBirth,
      healthCenterId: healthCenterId,
      isActive: isActive,
      personData:
          personData != null ? PersonModel.fromEntity(personData!) : null,
    );
  }
}*/
