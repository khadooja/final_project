import 'package:new_project/features/staff_management/domain/repositories/;ocation_repository.dart';

class GetAreasByCity {
  final LocationRepository repository;

  GetAreasByCity(this.repository);

  Future<List> call(String cityId) => repository.getAreasByCity(cityId);
}
