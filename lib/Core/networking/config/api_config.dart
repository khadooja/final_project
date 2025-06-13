import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // <-- Add this import

/*class ApiConfig {
 static const String baseUrl = 'http://10.0.2.2:8000/api/';
  static void configureDio(Dio dio) {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }
 /* static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api/'; // للويب
    } else {
      return 'http://10.0.2.2:8000/api/'; // للأندرويد
    }
  }

  static void configureDio(Dio dio) {
     dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }*/
}
*/
class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api/'; // للويب
    } else {
      return 'http://10.0.2.2:8000/api/'; // للأندرويد
    }
  }

  static void configureDio(Dio dio) {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }
}
