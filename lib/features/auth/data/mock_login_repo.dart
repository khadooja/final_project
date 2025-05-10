import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/auth/data/model/login_request_body.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:new_project/features/auth/data/repos/login_repo.dart';

class MockLoginRepo implements LoginRepo {
  @override
  Future<ApiResult<LoginResponse>> login(LoginRequestBody body) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // استخدم نفس البيانات في جميع الأماكن
    const mockUser = 'koko';
    const mockPass = '123';

    if (body.username.isEmpty || body.password.isEmpty) {
      return ApiResult.failure(
        ErrorHandler.handle(Exception('Username and password are required')),
      );
    }

    if (body.username == mockUser && body.password == mockPass) {
      return ApiResult.success(
        LoginResponse(
          token: 'mock_jwt_token',
          tokenType: 'Bearer',
          userName: 'Test User',
          role: 'admin',
          userId: 'user_123',
        ),
      );
    } else {
      return ApiResult.failure(
        ErrorHandler.handle(Exception('Invalid credentials')),
      );
    }
  }
}
