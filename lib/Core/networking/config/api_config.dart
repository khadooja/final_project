import 'package:dio/dio.dart';

class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000/api/';
  static void configureDio(Dio dio) {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }
}
