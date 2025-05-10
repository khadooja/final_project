// features/staff_management/domain/usecases/add_employee.dart
import 'package:dartz/dartz.dart';
import 'package:new_project/Core/utils/failure.dart';
import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';

class AddEmployee {
  final AdminRepository repository;

  AddEmployee({required this.repository});

  Future<Either<Failure, bool>> execute({
    required bool isPersonExist,
    required Map<String, dynamic> data,
  }) async {
    try {
      final result = isPersonExist
          ? await repository.addExistingPersonAsEmployee(
              data['personId'] as int,
              data,
            )
          : await repository.addNewEmployeeWithPerson(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
