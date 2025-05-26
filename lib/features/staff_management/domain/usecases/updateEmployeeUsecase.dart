import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/domain/repository/employeeRepository.dart';

class UpdateEmployeeUseCase {
  final EmployeeRepository repository;

  UpdateEmployeeUseCase({required this.repository});

  Future<ApiResult<EmployeeModel>> execute(
      String employeeId, EmployeeModel employeeModel) async {
    return await repository.updateEmployee(employeeId, employeeModel);
  }
}
