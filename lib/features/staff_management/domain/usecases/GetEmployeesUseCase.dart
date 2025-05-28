import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/data/model/showEmployeeModel.dart';
import 'package:new_project/features/staff_management/domain/repository/employeeRepository.dart';
import 'package:new_project/Core/networking/api_result.dart';

class GetEmployeesUseCase {
  final EmployeeRepository repository;
  GetEmployeesUseCase(this.repository);

  Future<ApiResult<List<Showemployeemodel>>> call() {
    return repository.getEmployees();
  }
}
