import 'package:new_project/Core/networking/config/api_config.dart';

class ChildEndpoints {
  String addChildren = '${ApiConfig.baseUrl}childern/store';
  // String getChildById = '${ApiConfig.baseUrl}children/{id}';

  String updateChild = '${ApiConfig.baseUrl}children/{id}';
  String getChildByIdentityCardNumber =
      '${ApiConfig.baseUrl}children/identityCardNumber/{identityCardNumber}';
  String getChildByName = '${ApiConfig.baseUrl}children/name/{name}';
  String getDropdownsData = '${ApiConfig.baseUrl}children/create';


  //new
  String getChildren = '${ApiConfig.baseUrl}childern';
  // String editChildren = '${ApiConfig.baseUrl}childern/{id}/edit';
  String getChildById(String id) => '${ApiConfig.baseUrl}childern/$id/edit';
}
