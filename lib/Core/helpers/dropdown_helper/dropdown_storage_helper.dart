import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relation_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationalitiesAndcities_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dropdown_keys.dart';

class DropdownStorageHelper {
  static Future<void> saveDropdownsData(
      NationalitiesAndCitiesModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(DropdownKeys.dropdownsData, jsonString);
  }

  static Future<NationalitiesAndCitiesModel?> getDropdownsData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(DropdownKeys.dropdownsData);
    if (jsonString == null) return null;

    final jsonMap = jsonDecode(jsonString);
    return NationalitiesAndCitiesModel.fromJson(jsonMap);
  }

  static Future<void> clearDropdownsData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(DropdownKeys.dropdownsData);
  }

  static Future<void> saveRelationshipTypes(
      List<RelationModel> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.map((e) => e.toJson()).toList());
    await prefs.setString(DropdownKeys.relationshipTypes, jsonString);
  }

  static Future<List<RelationModel>?> getRelationshipTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(DropdownKeys.relationshipTypes);
    if (jsonString == null) return null;

    final decoded = jsonDecode(jsonString) as List;
    return decoded.map((e) => RelationModel.fromJson(e)).toList();
  }

  static Future<void> setRelationshipTypes(
      List<RelationModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(DropdownKeys.nationalitiesKey, jsonString);
  }

  static Future<void> clearRelationshipTypes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(DropdownKeys.nationalitiesKey);
  }

  // إضافة دوال حفظ واسترجاع الجنسيات

  static Future<void> setNationalities(
      List<NationalityModel> nationalities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(nationalities.map((e) => e.toJson()).toList());
    await prefs.setString(DropdownKeys.nationalitiesKey, jsonString);
    debugPrint("Saved ${nationalities.length} nationalities to local storage");
  }

  static Future<List<NationalityModel>?> getNationalities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(DropdownKeys.nationalitiesKey);
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
    await prefs.remove(DropdownKeys.nationalitiesKey);
  }

  // ===================== cities =====================
  static Future<void> setCites(List<CityModel> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cities.map((e) => e.toJson()).toList());
    await prefs.setString(DropdownKeys.cityiesKey, jsonString);
    debugPrint("Saved ${cities.length} cities to local storage");
  }

  static Future<List<CityModel>?> getCities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(DropdownKeys.cityiesKey);
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
    await prefs.remove(DropdownKeys.cityiesKey);
  }

  // ===================== Countries =====================
  static Future<void> setCountry(List<CountryModel> countries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(countries.map((e) => e.toJson()).toList());
    await prefs.setString(DropdownKeys.areaKey, jsonString);
    debugPrint("Saved ${countries.length} cities to local storage");
  }

 static Future<List<CountryModel>?> getCountries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(DropdownKeys.areaKey);
    if (jsonString == null) return null;

    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => CountryModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("❌ Error decoding countries: $e");
      return null;
    }
  }
  static Future<void> clearCountries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(DropdownKeys.areaKey);
  }

// ===================== Special Cases =====================
  static Future<void> setSpecialCases(List<SpecialCase>  specialCases) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(specialCases.map((e) => e).toList());
    await prefs.setString(DropdownKeys.specialCasesKey, jsonString);
    debugPrint("Saved ${specialCases.length} special cases to local storage");
  }

static Future<List<SpecialCase>?> getSpecialCases() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(DropdownKeys.specialCasesKey);
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
    await prefs.remove(DropdownKeys.specialCasesKey);
  }


  static Future<void> clearAllDropdowns() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(DropdownKeys.nationalitiesKey);
    await prefs.remove(DropdownKeys.cityiesKey);
    await prefs.remove(DropdownKeys.specialCasesKey);
  }
}

