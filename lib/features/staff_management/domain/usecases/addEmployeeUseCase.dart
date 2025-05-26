import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/domain/repository/employeeRepository.dart';
class AddEmployeeUseCase {
  final EmployeeRepository repository;

  AddEmployeeUseCase(this.repository);

  Future<ApiResult<void>> execute(EmployeeModel model) {
    return repository.addEmployee(model);
  }
}
