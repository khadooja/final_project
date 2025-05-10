import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/auth/data/model/login_request_body.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';

class LoginRepo {
  final ApiServiceManual _apiService;

  LoginRepo(this._apiService);

  Future<ApiResult<LoginResponse>> login(LoginRequestBody body) async {
    try {
      if (body.username.isEmpty || body.password.isEmpty) {
        return ApiResult.failure(ErrorHandler.handle(
          Exception('Username and password are required'),
        ));
      }

      final response = await _apiService.login(body);
      print(
          '📦 API raw response............................................. ${response.toString()}');
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
