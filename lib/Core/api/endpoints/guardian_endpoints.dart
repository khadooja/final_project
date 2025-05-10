import 'package:new_project/Core/networking/config/api_config.dart';

class GuardianEndpoints {
  String addGuardian = '${ApiConfig.baseUrl}guardians';
  String updateGuardian = '${ApiConfig.baseUrl}guardians/{id}';
  String linkGuardianToChild =
      '${ApiConfig.baseUrl}children/{childId}/linkGuardian';

  // Relationship Types
  String getRelationshipTypes = '${ApiConfig.baseUrl}relationship_types';
}
