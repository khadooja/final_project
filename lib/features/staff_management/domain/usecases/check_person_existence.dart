import '../repositories/staff_repository.dart';

class CheckPersonExistence {
  final AdminRepository repository;

  CheckPersonExistence({required this.repository});

  Future<bool> call(String id) async {
    final person = await repository.checkPersonExistence(id);
    return person != null;
  }
}
