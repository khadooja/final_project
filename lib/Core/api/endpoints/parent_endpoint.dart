import 'package:new_project/Core/networking/config/api_config.dart';

class ParentEndpoint {
  String addFather = '${ApiConfig.baseUrl}father/store';
  String addMother = '${ApiConfig.baseUrl}mother/store';
  String getFathers = '${ApiConfig.baseUrl}getFathers';
  String getMothers = '${ApiConfig.baseUrl}getMothers';
  String updatFather = '${ApiConfig.baseUrl}Father/{id}';
  String updateMother = '${ApiConfig.baseUrl}Mother/{id}';
}
