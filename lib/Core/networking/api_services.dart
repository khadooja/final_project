import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Core/api/endpoints/api_endpoints.dart';
import 'package:new_project/Core/networking/config/api_config.dart';
import 'package:new_project/features/children_managment/data/model/CommonDropdownsChidModel.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relation_model.dart';
import 'package:new_project/features/personal_management/data/models/nationalitiesAndcities_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/auth/data/model/login_request_body.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/vaccination/stage/model/StageModel.dart';
import 'package:new_project/features/vaccination/vaccine/model/SimpleVaccineModel.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';

import '../../features/HelthCenter/model/helth_center.dart';
import '../../features/HelthCenter/model/location.dart';

class ApiServiceManual {
  final Dio _dio;

  ApiServiceManual({required Dio dio}) : _dio = dio;
  //ApiServiceManual({required Dio dio}) : _dio = dio;

  String getDioBaseUrl() => _dio.options.baseUrl; // Helper

  // Auth
  Future<LoginResponse> login(LoginRequestBody loginRequestBody) async {
    print('📡 ApiServiceManual - login - البيانات المرسلة: $loginRequestBody');
    try {
      final response = await _dio.post(
        ApiEndpoints.auth.login,
        data: loginRequestBody.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      // تسجيل الأخطاء هنا
      debugPrint('Login error: $e');
      throw Exception('حدث خطأ أثناء تسجيل الدخول');
    }
  }

  // Father
  /*Future<FatherModel> addFather(FatherModel fatherData) async {
  try {
    // 1. إعداد الـ headers مع Center-Id
    final options = Options(headers: {
      'Center-Id': '1', // أو القيمة الصحيحة لمركزك
      'Authorization': 'Bearer ${_dio.options.headers['Authorization']}',
      'Content-Type': 'application/json',
    });

    // 2. إرسال الطلب مع الـ headers
    final response = await _dio.post(
      ApiEndpoints.parent.addFather,
      data: fatherData.toJson(),
      options: options, // إضافة الـ options هنا
    );

    // 3. معالجة الاستجابة
    if (response.statusCode == 200 || response.statusCode == 201) {
      return FatherModel.fromJson(response.data);
    } else {
      throw Exception('فشل في إضافة الأب: ${response.statusCode}');
    }
  } on DioException catch (e) {
    // 4. معالجة الأخطاء
    if (e.response != null) {
      throw Exception('خطأ من الخادم: ${e.response?.data}');
    } else {
      throw Exception('خطأ في الاتصال: ${e.message}');
    }
  }
}*/
Future<FatherModel> addFather(FatherModel fatherData) async {
    final response = await _dio.post(
      ApiEndpoints.parent.addFather,
      data: fatherData.toJson(),
      
    );
    return FatherModel.fromJson(response.data);
 
}
  // Mother
  Future<MotherModel> addMother(MotherModel motherData) async {
    final response = await _dio.post(
      ApiEndpoints.parent.addMother,
      data: motherData.toJson(),
      
    );
    return MotherModel.fromJson(response.data);
  }

  // Person Operations (Generic)
  Future<SearchPersonResponse> searchPerson(
  String identity_card_number,
  PersonType person_type,
) async {
  print('📡 ApiServiceManual - searchPerson - البيانات المرسلة: $identity_card_number$person_type');

  final response = await _dio.post(
    ApiEndpoints.personal.searchPerson,
    data: {
      'identity_card_number': identity_card_number,
      'person_type': person_type.name,
    },
  );

  return SearchPersonResponse.fromJson(response.data);
}

  Future<PersonModel> updatePerson(
      PersonType type, String id, Map<String, dynamic> data) async {
    final response = await _dio.put(
      '/${type.endpoint}/$id',
      data: data,
    );
    return PersonModel.fromJson(response.data);
  }

  Future<NationalitiesAndCitiesModel> getNationalitiesAndCities(
      PersonType type) async {
    final response =
        await _dio.get(ApiEndpoints.personal.nationalitiesAndCities);
    return NationalitiesAndCitiesModel.fromJson(response.data);
  }


  Future<List<Map<String, dynamic>>> getAreasByCity(PersonType type, String cityName) async {
  final response = await _dio.get('${ApiEndpoints.personal.areasByCity}/$cityName');
  return (response.data as List).cast<Map<String, dynamic>>(); // التحويل الصريح
}

  Future<void> toggleActivationPerson(
      PersonType type, String id, Map<String, dynamic> data) async {
    await _dio.patch(
      '/${type.endpoint}/$id/status',
      data: data,
    );
  }

  // Child
  Future<CommonDropdownsChidModel> getDropdownsData( PersonType type) async {
  final response = await _dio.get(ApiEndpoints.child.getDropdownsData);
  return CommonDropdownsChidModel.fromJson(response.data['data']);
}

  Future<ChildModel> addChild(ChildModel childData) async {
    final response = await _dio.post(
      ApiEndpoints.child.addChildren,
      data: childData.toJson(),
    );
    return ChildModel.fromJson(response.data);
  }

  // ADD THIS GENERIC GET METHOD
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    print('📞 ApiServiceManual: Calling _dio.get with path: "$path"');

    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response
          .data; // Return the decoded data (usually Map<String, dynamic> or List)
    } on DioException catch (e) {
      // You might want more specific error handling or re-throwing
      debugPrint('GET error for path "$path": $e');
      debugPrint('DioError Response: ${e.response}');
      // Consider using your ErrorHandler here if you have one for DioException
      throw Exception('فشل الاتصال بالخادم أو جلب البيانات من المسار: $path');
    } catch (e) {
      debugPrint('Unexpected GET error for path "$path": $e');
      throw Exception('حدث خطأ غير متوقع أثناء جلب البيانات من المسار: $path');
    }
  }

  Future<ChildModel> updateChild(String id, ChildModel data) async {
    final response = await _dio.put(
      '/child/update/$id',
      data: data.toJson(),
    );
    return ChildModel.fromJson(response.data);
  }

  // Guardian
  Future<GurdianModel> addGuardian(GurdianModel guardianData) async {
    final response = await _dio.post(
      ApiEndpoints.guardian.addGuardian,
      data: guardianData.toJson(),
    );
    return GurdianModel.fromJson(response.data);
  }

  Future<GurdianModel> updateGuardian(
      String id, GurdianModel guardianData) async {
    final response = await _dio.put(
      ApiEndpoints.guardian.updateGuardian.replaceFirst("{id}", id),
      data: guardianData.toJson(),
    );
    return GurdianModel.fromJson(response.data);
  }

  // Relationship Types
  Future<List<RelationModel>> getRelationshipTypes() async {
    final response = await _dio.get(ApiEndpoints.guardian.guardiancreate);
    return (response.data as List)
        .map((item) => RelationModel.fromJson(item))
        .toList();
  }

  // Link Guardian to Child
  Future<void> linkGuardianToChild(
      String guardianId, String childId, String relationshipTypeId) async {
    await _dio.post(
      ApiEndpoints.guardian.linkGuardianToChild
          .replaceFirst("{childId}", childId),
      data: {
        "guardian_id": guardianId,
        "relationship_type_id": relationshipTypeId,
      },
    );
  }



  Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      debugPrint('POST error: $e');

      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;

        if (errorData is Map<String, dynamic>) {
          // حالة وجود رسائل تحقق
          if (errorData.containsKey('errors')) {
            throw errorData['errors']; // 🔴 نرمي Map تحتوي على الأخطاء
          }

          // رسالة عامة
          if (errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        }

        throw Exception('حدث خطأ غير متوقع من السيرفر');
      }

      throw Exception('فشل الاتصال بالخادم');
    }
  }

  Future<List<SimpleVaccineModel>> getVaccines() async {
    try {
      final response = await _dio.get('${ApiConfig.baseUrl}dose/create');
      final vaccinations = response.data['Vaccinations'] as List;

      return vaccinations
          .map((item) => SimpleVaccineModel.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint("خطأ أثناء تحميل التطعيمات: $e");
      throw Exception('فشل في تحميل التطعيمات');
    }
  }

  Future<Map<String, dynamic>> getVaccine() async {
    final response = await _dio.get('${ApiConfig.baseUrl}vaccines');
    return response.data;
  }

  Future<Map<String, dynamic>> getVaccineEditData(int id) async {
    final res = await _dio.get('${ApiConfig.baseUrl}vaccines/$id/edit');
    return res.data;
  }

  Future<void> updateVaccine(int id, VaccineModel model) async {
    await _dio.put('${ApiConfig.baseUrl}vaccines/$id', data: model.toJson());
  }

  Future<void> toggleVaccineStatus(int id) async {
    await _dio.patch('${ApiConfig.baseUrl}vaccines/$id/status');
  }

  // جلب المراحل
  Future<List<StageModel>> fetchStages() async {
    try {
      final response = await _dio.get('${ApiConfig.baseUrl}stages/create');

      if (response.statusCode == 200) {
        final data = response.data;

        List<dynamic> stagesJson;
        if (data is List) {
          stagesJson = data;
        } else if (data is Map &&
            data['stage'] != null &&
            data['stage'] is List) {
          stagesJson = data['stage'];
        } else {
          throw Exception('البيانات المستلمة غير متوقعة: $data');
        }

        return stagesJson.map((e) => StageModel.fromJson(e)).toList();
      } else {
        throw Exception('فشل في جلب المراحل - الكود: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ أثناء جلب المراحل: $e');
    }
  }

// إضافة تطعيم
  Future<bool> addVaccine(VaccineModel vaccine) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}vaccine/store',
        data: vaccine.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('فشل في إضافة التطعيم: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ أثناء إضافة التطعيم: $e');
    }
  }

  Future<List<Location>> fetchCities() async {
    final response =
        await _dio.get('${ApiConfig.baseUrl}citiesAndNationalities');
    if (response.statusCode == 200) {
      final List<dynamic> citiesJson = response.data['cities'];
      return citiesJson.map((e) => Location.fromJson(e)).toList();
    } else {
      throw Exception('فشل تحميل المدن');
    }
  }

  Future<List<Location>> fetchAreas(String cityName) async {
    final encodedCityName = Uri.encodeComponent(cityName);
    final response =
        await _dio.get('${ApiConfig.baseUrl}areas/$encodedCityName');
    if (response.statusCode == 200) {
      final List<dynamic> areasJson = response.data;
      return areasJson.map((e) => Location.fromJson(e)).toList();
    } else {
      throw Exception('فشل تحميل المناطق');
    }
  }

  Future<bool> addHealthCenter(HealthCenter center) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}healthCenter/store',
        data: center.toJson(),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.data}');

      return response.statusCode == 201;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchClinics() async {
    final response = await _dio.get('${ApiConfig.baseUrl}healthCenter/index');
    return response.data;
  }

  Future<void> toggleHealthStatus(int id) async {
    await _dio.patch('${ApiConfig.baseUrl}healthCenter/$id/status');
  }

  Future<void> updateHealth(int id, HealthCenter model) async {
    await _dio.put('${ApiConfig.baseUrl}healthCenter/$id',
        data: model.toJson());
  }

  Future<Map<String, dynamic>> getHealthEditData(int id) async {
    final res = await _dio.get('${ApiConfig.baseUrl}healthCenter/$id/edit');
    return res.data;
  }


 Future<Map<String, dynamic>> fetchReportData({int? centerId}) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}Reports',
        queryParameters: centerId != null ? {'healthCenter': centerId} : null,
      );

      // تحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('فشل في تحميل البيانات: ${response.statusCode}');
      }
    } catch (e) {
      // في حالة حدوث خطأ في الاتصال أو المعالجة
      throw Exception('حدث خطأ أثناء استرجاع البيانات: $e');
    }
  }
}
