import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/staff_management/data/dataSource.dart/EmployeeRemoteDataSource.dart';
import 'package:new_project/features/staff_management/data/model/CreateEmployeeDataModel.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/domain/repository/employeeRepository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<EmployeeModel>> addEmployee(EmployeeModel employee) {
    return remoteDataSource.addEmployee(employee);
  }

  @override
  Future<ApiResult<EmployeeModel>> updateEmployee(
      String id, EmployeeModel employee) {
    return remoteDataSource.updateEmployee(id, employee);
  }

  @override
  Future<ApiResult<CreateEmployeeDataModel>> fetchCreateEmployeeData() {
    return remoteDataSource.fetchCreateEmployeeData();
  }

  @override
  Future<ApiResult<List<EmployeeModel>>> getEmployees() {
    return remoteDataSource.getEmployees();
  }
}
