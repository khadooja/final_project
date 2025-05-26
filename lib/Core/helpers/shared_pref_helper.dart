import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/networking/dio_factory.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StorageHelper {
  StorageHelper._(); // Prevent instantiation

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static late SharedPreferences prefs;

  // 🟡 هذه الدالة تحتاج تناديها في البداية
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // ===================== Unified Storage =====================

  // دالة لحفظ البيانات (SharedPreferences و SecureStorage)

  // Define a method to get a string value from the shared preferences or secure storage
  static Future<String?> getString(String key, {String? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<String?> getSecuredString(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Method to store data securely
  static Future<void> setSecuredString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<void> saveData(String key, dynamic value,
      {bool isSecure = false}) async {
    if (isSecure) {
      await _secureStorage.write(key: key, value: value);
      debugPrint("SecureStorage: Set [$key]: $value");
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else {
        debugPrint("SharedPrefHelper: Unsupported type for key [$key]");
      }
      debugPrint("SharedPreferences: Set [$key]: $value");
    }
  }

  // دالة للحصول على البيانات (SharedPreferences و SecureStorage)
  static Future<dynamic> getData(String key,
      {dynamic defaultValue, bool isSecure = false}) async {
    if (isSecure) {
      final value = await _secureStorage.read(key: key);
      debugPrint("SecureStorage: Get [$key]: ${value ?? defaultValue}");
      return value ?? defaultValue;
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (defaultValue is String) {
        return prefs.getString(key) ?? defaultValue;
      } else if (defaultValue is int) {
        return prefs.getInt(key) ?? defaultValue;
      } else if (defaultValue is bool) {
        return prefs.getBool(key) ?? defaultValue;
      } else if (defaultValue is double) {
        return prefs.getDouble(key) ?? defaultValue;
      } else {
        return defaultValue;
      }
    }
  }

  // دالة لحذف البيانات (SharedPreferences و SecureStorage)
  static Future<void> removeData(String key, {bool isSecure = false}) async {
    if (isSecure) {
      await _secureStorage.delete(key: key);
      debugPrint("SecureStorage: Removed key => [$key]");
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      debugPrint("SharedPreferences: Removed key => [$key]");
    }
  }

  // دالة لحذف جميع البيانات (SharedPreferences و SecureStorage)
  static Future<void> clearAllData({bool isSecure = false}) async {
    if (isSecure) {
      await _secureStorage.deleteAll();
      debugPrint("SecureStorage: Cleared all secure storage data.");
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      debugPrint("SharedPreferences: Cleared all data.");
    }
  }

  // ===================== Example Functions =====================

  // حفظ بيانات المستخدم في SecureStorage و SharedPreferences
  static Future<void> saveUserData(LoginResponse user) async {
    final token = '${user.tokenType} ${user.token}';

    // حفظ البيانات في التخزين الآمن
    await setSecuredString(SharedPrefKeys.userToken, token);
    await setSecuredString(SharedPrefKeys.userName, user.userName ?? '');
    await setSecuredString(SharedPrefKeys.userRole, user.role ?? '');
    await setSecuredString(
        SharedPrefKeys.userId, user.userId?.toString() ?? '');
    await setSecuredString(
        SharedPrefKeys.centerId, user.centerId?.toString() ?? '');

    // تحديث التوكن والهيدر في Dio مباشرة
    DioFactory.setTokenIntoHeaderAfterLogin(
        token, user.centerId?.toString() ?? '');

    debugPrint('User data saved successfully');
  }

  // استرجاع بيانات المستخدم من SecureStorage و SharedPreferences
  static Future<LoginResponse> getSavedUserData() async {
    final userId = await getData('userId', isSecure: true);
final userRole = await getData('userRole', isSecure: true);
final userName = await getData('userName', isSecure: true);
final centerId = await getData('centerId', isSecure: true);
    final token = await getData('userToken', isSecure: true);

    String tokenType = '';
    String pureToken = '';
    if (token.contains(' ')) {
      final parts = token.split(' ');
      if (parts.length >= 2) {
        tokenType = parts[0];
        pureToken = parts[1];
      }
    }

    return LoginResponse(
      tokenType: tokenType,
      token: pureToken,
      userId: userId,
      role: userRole,
      userName: userName,
      centerId: centerId,
    );
  }
}
