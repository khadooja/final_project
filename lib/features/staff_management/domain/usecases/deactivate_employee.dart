import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';

class DeactivateEmployee {
  final AdminRepository repository;

  DeactivateEmployee(this.repository);

  Future<bool> call(String employeeId) async {
    return await repository.deactivateEmployee(employeeId);
  }
}
