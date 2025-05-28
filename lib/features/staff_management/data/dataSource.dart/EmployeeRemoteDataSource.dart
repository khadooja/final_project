import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';
import 'package:new_project/features/staff_management/data/model/CreateEmployeeDataModel.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/data/model/showEmployeeModel.dart';

abstract class EmployeeRemoteDataSource extends PersonRemoteDataSource {
  Future<ApiResult<EmployeeModel>> addEmployee(EmployeeModel employeeModel);
  Future<ApiResult<EmployeeModel>> updateEmployee(
      String employeeId, EmployeeModel employeeModel);
  Future<ApiResult<CreateEmployeeDataModel>> fetchCreateEmployeeData();

  Future<ApiResult<List<Showemployeemodel>>> getEmployees();
}
