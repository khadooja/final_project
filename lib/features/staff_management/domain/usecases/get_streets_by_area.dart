import 'package:new_project/features/staff_management/domain/repositories/;ocation_repository.dart';

class GetStreetsByArea {
  final LocationRepository repository;

  GetStreetsByArea(this.repository);

  Future<List> call(String areaId) => repository.getStreetsByArea(areaId);
}
