import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class EmployeesResponse {
  final List<EmployeeModel> employees;
  final int totalEmployees;
  final int currentPage;
  final int totalPages;

  EmployeesResponse({
    required this.employees,
    required this.totalEmployees,
    required this.currentPage,
    required this.totalPages,
  });

  factory EmployeesResponse.fromJson(Map<String, dynamic> json) {
    List<EmployeeModel> employees = [];
    if (json['employees'] is List) {
      employees = (json['employees'] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList();
    }

    return EmployeesResponse(
      employees: employees,
      totalEmployees: json['totalEmployees'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
