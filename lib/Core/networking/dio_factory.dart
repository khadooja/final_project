import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
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
  String? token;
  String? centerId;
  
  try {
    token = await StorageHelper.getSecuredString(SharedPrefKeys.userToken);
    centerId = await StorageHelper.getString(SharedPrefKeys.centerId);
  } catch (e) {
    debugPrint('[ERROR] Failed to get auth data: $e');
  }

  dio?.options.headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 
      'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
    if (centerId?.isNotEmpty ?? false) ...{
      'X-Center-ID': centerId!,
      'Center-Id': centerId,
    },
  };

  if (centerId == null || centerId.isEmpty) {
    debugPrint('[INFO] Request sent without Center-ID');
  }
}
/* static Future<void> addDioHeaders() async {
  try {
    // جلب التوكن و Center-ID بشكل متوازي لتحسين الأداء
    final (token, centerId) = await (
      StorageHelper.getSecuredString(SharedPrefKeys.userToken),
      StorageHelper.getString(SharedPrefKeys.centerId, defaultValue: ''),
    ).wait;

    // تنظيف التوكن من أي Bearer مكرر
    final cleanedToken = token?.trim().startsWith('Bearer ') ?? false
        ? token!.trim()
        : token != null ? 'Bearer ${token.trim()}' : null;

    // إنشاء headers الأساسية
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // إضافة التوكن إذا كان موجوداً
    if (cleanedToken != null) {
      headers['Authorization'] = cleanedToken;
    }

    // إضافة Center-ID إذا كان موجوداً
    if (centerId?.isNotEmpty ?? false) {
      headers.addAll({
        'X-Center-ID': centerId!,
        'Center-Id': centerId,
      });
    } else {
      debugPrint('[WARNING] Center ID is missing - Proceeding with basic headers');
    }

    // تعيين الـ headers النهائية
    dio?.options.headers = headers;

  } catch (e) {
    debugPrint('[ERROR] Failed to set headers: $e');
    // Fallback إلى headers أساسية في حالة الخطأ
    dio?.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}*/
  static void setTokenIntoHeaderAfterLogin(String token, String centerId) {
    // أيضًا تأكد هنا من أن Bearer لم تُكرر
    if (!token.startsWith('Bearer ')) {
      token = 'Bearer $token';
    }

    dio?.options.headers = {
      'Authorization': token,
      'X-Center-ID': centerId,
      'Center-Id': centerId,
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
