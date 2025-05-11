import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/networking/dio_factory.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StorageHelper {
  StorageHelper._(); // Prevent instantiation

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

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
    final token = await getData('userToken', isSecure: true);
    final userId = await getData('userId');
    final userRole = await getData('userRole');
    final userName = await getData('userName');
    final centerId = await getData('centerId');

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

  static Future<void> setRelationshipTypes(
      List<RelationshipTypeModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(SharedPrefKeys.nationalitiesKey, jsonString);
  }

  static Future<List<RelationshipTypeModel>?> getRelationshipTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(SharedPrefKeys.nationalitiesKey);
    if (jsonString == null) return null;
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => RelationshipTypeModel.fromJson(e)).toList();
  }

  static Future<void> clearRelationshipTypes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefKeys.nationalitiesKey);
  }

  // إضافة دوال حفظ واسترجاع الجنسيات

  static Future<void> setNationalities(
      List<NationalityModel> nationalities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(nationalities.map((e) => e.toJson()).toList());
    await prefs.setString(SharedPrefKeys.nationalitiesKey, jsonString);
    debugPrint("Saved ${nationalities.length} nationalities to local storage");
  }

  static Future<List<NationalityModel>?> getNationalities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(SharedPrefKeys.nationalitiesKey);
    if (jsonString == null) return null;

    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => NationalityModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error parsing nationalities: $e");
      return null;
    }
  }

  static Future<void> clearNationalities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefKeys.nationalitiesKey);
  }

  // ===================== cities =====================
  static Future<void> setCites(List<CityModel> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cities.map((e) => e.toJson()).toList());
    await prefs.setString(SharedPrefKeys.cityiesKey, jsonString);
    debugPrint("Saved ${cities.length} cities to local storage");
  }

  static Future<List<CityModel>?> getCities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(SharedPrefKeys.cityiesKey);
    if (jsonString == null) return null;

    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => CityModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error parsing cities: $e");
      return null;
    }
  }

  static Future<void> clearCties() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefKeys.cityiesKey);
  }

  // ===================== Countries =====================
  static Future<void> setCountry(List<CountryModel> countries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(countries.map((e) => e.toJson()).toList());
    await prefs.setString(SharedPrefKeys.countriesKey, jsonString);
    debugPrint("Saved ${countries.length} cities to local storage");
  }

  static Future<List<CountryModel>?> getCountries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(SharedPrefKeys.countriesKey);
    if (jsonString == null) return null;

    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => CountryModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error parsing countries: $e");
      return null;
    }
  }

  static Future<void> clearCountries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefKeys.countriesKey);
  }

// ===================== Special Cases =====================
  static Future<void> setSpecialCases(List<SpecialCase> specialCases) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(specialCases.map((e) => e.toJson()).toList());
    await prefs.setString(SharedPrefKeys.specialCasesKey, jsonString);
    debugPrint("Saved ${specialCases.length} special cases to local storage");
  }

  static Future<List<SpecialCase>?> getSpecialCases() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(SharedPrefKeys.specialCasesKey);
    if (jsonString == null) return null;

    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => SpecialCase.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error parsing special cases: $e");
      return null;
    }
  }

  static Future<void> clearSpecialCases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefKeys.specialCasesKey);
  }
}
