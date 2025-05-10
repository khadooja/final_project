import 'dart:convert';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';
import 'package:new_project/features/personal_management/data/models/common_dropdowns_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dropdown_keys.dart';

class DropdownStorageHelper {
  static Future<void> saveDropdownsData(CommonDropDownsResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(DropdownKeys.dropdownsData, jsonString);
  }

  static Future<CommonDropDownsResponse?> getDropdownsData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(DropdownKeys.dropdownsData);
    if (jsonString == null) return null;

    final jsonMap = jsonDecode(jsonString);
    return CommonDropDownsResponse.fromJson(jsonMap);
  }

  static Future<void> clearDropdownsData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(DropdownKeys.dropdownsData);
  }

  static Future<void> saveRelationshipTypes(
      List<RelationshipTypeModel> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.map((e) => e.toJson()).toList());
    await prefs.setString(DropdownKeys.relationshipTypes, jsonString);
  }

  static Future<List<RelationshipTypeModel>?> getRelationshipTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(DropdownKeys.relationshipTypes);
    if (jsonString == null) return null;

    final decoded = jsonDecode(jsonString) as List;
    return decoded.map((e) => RelationshipTypeModel.fromJson(e)).toList();
  }
}
