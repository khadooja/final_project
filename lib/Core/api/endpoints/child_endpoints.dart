import 'package:new_project/Core/networking/config/api_config.dart';

class ChildEndpoints {
  String addChild = '${ApiConfig.baseUrl}childern/store';
  String getChildren = '${ApiConfig.baseUrl}children';
  String getChildById = '${ApiConfig.baseUrl}children/{id}';
  String updateChild = '${ApiConfig.baseUrl}children/{id}';
  String getChildByIdentityCardNumber =
      '${ApiConfig.baseUrl}children/identityCardNumber/{identityCardNumber}';
  String getChildByName = '${ApiConfig.baseUrl}children/name/{name}';
  String getDropdownsData  =
      '${ApiConfig.baseUrl}children/create';
}
