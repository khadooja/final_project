import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/staff_management/data/model/CreateEmployeeDataModel.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/data/model/showEmployeeModel.dart';

abstract class EmployeeRepository {
  Future<ApiResult<EmployeeModel>> addEmployee(EmployeeModel employee);
  Future<ApiResult<EmployeeModel>> updateEmployee(
      String id, EmployeeModel employee);
  Future<ApiResult<CreateEmployeeDataModel>> fetchCreateEmployeeData();
  Future<ApiResult<List<Showemployeemodel>>> getEmployees();
}
