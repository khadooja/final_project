// import 'package:new_project/features/staff_management/data/model/HealthCenterModel.dart';

// class CreateEmployeeDataModel {
//   final Map<String, String> roles;
//   final List<HealthCenterModel> healthCenters;

//   CreateEmployeeDataModel({
//     required this.roles,
//     required this.healthCenters,
//   });

//   factory CreateEmployeeDataModel.fromJson(Map<String, dynamic> json) {
//     final rawRoles = Map<String, String>.from(json['roles']);
//     final rawHealth = json['healthCenter'];
//     List<HealthCenterModel> centers = [];

//     if (rawHealth is List) {
//       centers = rawHealth
//           .map<HealthCenterModel>((e) => HealthCenterModel.fromJson(e))
//           .toList();
//     } else if (rawHealth is Map<String, dynamic>) {
//       centers = [HealthCenterModel.fromJson(rawHealth)];
//     }

//     return CreateEmployeeDataModel(
//       roles: rawRoles,
//       healthCenters: centers,
//     );
//   }
// }
import 'package:new_project/features/staff_management/data/model/HealthCenterModel.dart';
import 'package:new_project/features/staff_management/data/model/Role.dart';

class CreateEmployeeDataModel {
  final List<Role> roles;
  final List<HealthCenterModel> healthCenters;

  CreateEmployeeDataModel({
    required this.roles,
    required this.healthCenters,
  });

  factory CreateEmployeeDataModel.fromJson(Map<String, dynamic> json) {
    final rolesMap = json['roles'] as Map<String, dynamic>;
    final healthCenterData = json['healthCenter'];

    List<HealthCenterModel> parsedHealthCenters;
    if (healthCenterData is List) {
      parsedHealthCenters =
          healthCenterData.map((e) => HealthCenterModel.fromJson(e)).toList();
    } else if (healthCenterData is Map<String, dynamic>) {
      parsedHealthCenters = [HealthCenterModel.fromJson(healthCenterData)];
    } else {
      parsedHealthCenters = [];
    }

    return CreateEmployeeDataModel(
      roles: rolesMap.entries
          .map((entry) => Role(key: entry.key, value: entry.value))
          .toList(),
      healthCenters: parsedHealthCenters,
    );
  }
}
