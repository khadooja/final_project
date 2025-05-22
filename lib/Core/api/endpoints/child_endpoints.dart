import 'package:new_project/Core/networking/config/api_config.dart';

class ChildEndpoints {
  String addChild = '${ApiConfig.baseUrl}children';
  String createChild = '${ApiConfig.baseUrl}childern/create';
  String getChildren = '${ApiConfig.baseUrl}childern';
  // String getChildren = 'children';
  String getChildById = '${ApiConfig.baseUrl}children/{id}';
  String updateChild = '${ApiConfig.baseUrl}children/{id}';
  String getChildByIdentityCardNumber =
      '${ApiConfig.baseUrl}children/identityCardNumber/{identityCardNumber}';
  String getChildByName = '${ApiConfig.baseUrl}children/name/{name}';
}
