import 'package:dio/dio.dart';
import 'package:new_project/Core/api/endpoints/api_endpoints.dart';
import 'package:new_project/features/children_managment/data/model/CommonDropdownsChidModel.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/personal_management/data/models/nationalitiesAndcities_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/auth/data/model/login_request_body.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';

class ApiServiceManual {
  final Dio _dio;

  ApiServiceManual({required Dio dio}) : _dio = dio;
  //ApiServiceManual({required Dio dio}) : _dio = dio;
  // Auth
  Future<LoginResponse> login(LoginRequestBody loginRequestBody) async {
    final response = await _dio.post(
      ApiEndpoints.auth.login,
      data: loginRequestBody.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  // Father
  Future<FatherModel> addFather(FatherModel fatherData) async {
    final response = await _dio.post(
      '/father',
      data: fatherData.toJson(),
    );
    return FatherModel.fromJson(response.data);
  }

  // Mother
  Future<MotherModel> addMother(MotherModel motherData) async {
    final response = await _dio.post(
      '/mother',
      data: motherData.toJson(),
    );
    return MotherModel.fromJson(response.data);
  }

  // Person Operations (Generic)
  Future<PersonModel> searchPerson(
      PersonType type, Map<String, dynamic> data) async {
    final response = await _dio.post(
      '/${type.endpoint}/search',
      data: data,
    );
    return PersonModel.fromJson(response.data);
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
        await _dio.get('/${type.endpoint}/nationalities-and-cities');
    return NationalitiesAndCitiesModel.fromJson(response.data);
  }

  Future<List<String>> getAreasByCity(PersonType type, String cityName) async {
    final response = await _dio.get(
      '/${type.endpoint}/areas',
      queryParameters: {'city_name': cityName},
    );
    return (response.data as List).map((item) => item.toString()).toList();
  }

  Future<void> toggleActivationPerson(
      PersonType type, String id, Map<String, dynamic> data) async {
    await _dio.patch(
      '/${type.endpoint}/$id/status',
      data: data,
    );
  }

  // Child
  Future<ChildModel> addChild(ChildModel childData) async {
    final response = await _dio.post(
      ApiEndpoints.child.addChild,
      data: childData.toJson(),
    );
    return ChildModel.fromJson(response.data);
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
  Future<List<RelationshipTypeModel>> getRelationshipTypes() async {
    final response = await _dio.get(ApiEndpoints.guardian.getRelationshipTypes);
    return (response.data as List)
        .map((item) => RelationshipTypeModel.fromJson(item))
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

  Future<CommonDropdownsChidModel> getNationalitiesAndCitiesUseCase(
      PersonType type) async {
    final response =
        await _dio.get('/${type.endpoint}/nationalities-and-cities-usecase');
    return CommonDropdownsChidModel.fromJson(response.data);
  }
}
