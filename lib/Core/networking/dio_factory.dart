import 'package:dio/dio.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/networking/config/api_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      await addDioHeaders();
      addDioInterceptor();
    }

    return dio!;
  }

  static void clearHeaders() {
    dio?.options.headers.clear();
  }

  static Future<void> addDioHeaders() async {
    String? token =
        await StorageHelper.getSecuredString(SharedPrefKeys.userToken);
    String? centerId = await StorageHelper.getString(SharedPrefKeys.centerId,
        defaultValue: '');

    // تأكد أن التوكن لا يحتوي على Bearer مكرر
    if (token != null && centerId != null) {
      if (!token.startsWith('Bearer ')) {
        token = 'Bearer $token';
      }

      dio?.options.headers = {
        'Accept': 'application/json',
        'Authorization': token,
        'X-Center-ID': centerId,
      };
    } else {
      dio?.options.headers = {
        'Accept': 'application/json',
      };
    }
  }

  static void setTokenIntoHeaderAfterLogin(String token, String centerId) {
    // أيضًا تأكد هنا من أن Bearer لم تُكرر
    if (!token.startsWith('Bearer ')) {
      token = 'Bearer $token';
    }

    dio?.options.headers = {
      'Authorization': token,
      'X-Center-ID': centerId,
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }

  // Add retry mechanism
  static Future<Response?> retryRequest(Function request,
      {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        return await request();
      } catch (e) {
        if (i == retries - 1) {
          rethrow; // Re-throw the exception if we've reached the maximum retries
        }
      }
    }
    return null;
  }
}
