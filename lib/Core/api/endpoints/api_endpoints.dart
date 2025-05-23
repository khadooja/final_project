import 'package:new_project/Core/api/endpoints/auth_endpoints.dart';
import 'package:new_project/Core/api/endpoints/child_endpoints.dart';
import 'package:new_project/Core/api/endpoints/employee_endpoints.dart';
import 'package:new_project/Core/api/endpoints/guardian_endpoints.dart';
import 'package:new_project/Core/api/endpoints/parent_endpoint.dart';
import 'package:new_project/Core/api/endpoints/personal_endpoints.dart';

class ApiEndpoints {
  static AuthEndpoints auth = AuthEndpoints();
  static ChildEndpoints child = ChildEndpoints();
  static EmployeeEndpoints employee = EmployeeEndpoints();
  static PersonalEndpoints personal = PersonalEndpoints();
  static ParentEndpoint parent = ParentEndpoint();
  static GuardianEndpoints guardian = GuardianEndpoints();


  
}
