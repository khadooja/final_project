import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/data/model/employeeResponse.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

abstract class AdminRepository {
  Future<PersonModel?> checkPersonExistence(String nationalId);
  Future<bool> addNewEmployeeWithPerson(Map<String, dynamic> data);
  Future<bool> addExistingPersonAsEmployee(
      int personId, Map<String, dynamic> employeeData);
  Future<List<EmployeeModel>> fetchEmployees();
  //Future<EmployeeModel?> fetchEmployeeById(String nationalId);
  Future<List<EmployeesResponse>> fetchEmployeesWithPagination();
  Future<bool> updateEmployee(EmployeeModel employee);
  Future<bool> deactivateEmployee(String employeeId);
  Future<Map<String, dynamic>> fetchDropdownData();
}
