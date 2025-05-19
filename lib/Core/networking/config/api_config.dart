import 'package:dio/dio.dart';
import 'dart:io';

class ApiConfig {
  static late String baseUrl;

  static void configureDio(Dio dio) {
    // تحقق هل التطبيق يعمل على Android emulator
    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:8000/api/';
    } else {
      baseUrl = 'http://localhost:8000/api/';
    }

    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }
}

/*
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000/api/';
  static void configureDio(Dio dio) {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }
}*/
