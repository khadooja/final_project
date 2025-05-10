import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/api_result.dart';

abstract class BaseRemoteDataSource {
  Future<ApiResult<T>> callApi<T>(Future<T> Function() request) async {
    try {
      final result = await request();
      return ApiResult.success(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
