import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

class DropdownMapper {
  static List<String> mapNationalitiesToNames(List<NationalityModel> list) {
    return list.map((e) => e.name).toList();
  }
}
