import 'package:new_project/Core/networking/config/api_config.dart';

class EmployeeEndpoints {
  String addEmployee = '${ApiConfig.baseUrl}employees';
  String getEmployees = '${ApiConfig.baseUrl}employees';
  String getEmployeeById = '${ApiConfig.baseUrl}employees/{id}';
  String updateEmployee = '${ApiConfig.baseUrl}employees/{id}';
  String getEmployeeByIdentityCardNumber =
      '${ApiConfig.baseUrl}employees/identityCardNumber/{identityCardNumber}';
}
