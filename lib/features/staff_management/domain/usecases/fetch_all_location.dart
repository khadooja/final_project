import 'package:new_project/features/staff_management/domain/repositories/;ocation_repository.dart';

class FetchAllLocations {
  final LocationRepository repository;

  FetchAllLocations(this.repository);

  Future<void> call() => repository.fetchAllLocations();
}
