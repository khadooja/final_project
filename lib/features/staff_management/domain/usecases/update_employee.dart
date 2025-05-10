import 'package:new_project/features/staff_management/data/datasources/staff_remote_data_source.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
//import 'package:new_project/features/staff_management/domain/entities/employee.dart';

class UpdateEmployee {
  final AdminRemoteDataSource adminRemoteDataSource;

  UpdateEmployee({required this.adminRemoteDataSource});

  Future<void> execute(EmployeeModel employee) async {
    final employeeModely = EmployeeModel(
      id: employee.id,
      employmentDate: employee.employmentDate,
      dateOfBirth: employee.dateOfBirth,
      healthCenterId: employee.healthCenterId,
      isActive: employee.isActive,
    );
    await adminRemoteDataSource.updateEmployee(employeeModely);
  }
}
