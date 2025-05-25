import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/BaseRemoteDataSource.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';
import 'package:new_project/features/personal_management/data/models/SimpleNationalityModel.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

class PersonRemoteDataSourceImpl extends BaseRemoteDataSource
    implements PersonRemoteDataSource {
  final ApiServiceManual _apiService;

  PersonRemoteDataSourceImpl(this._apiService);

  @override
/*Future<ApiResult<SearchPersonResponse?>> searchPersonById(
  String identityCardNumber,
  PersonType type,
) async {
  print('🔍 [1] بدء البحث عن الشخص - رقم الهوية: $identityCardNumber');
  print('📌 نوع الشخص: ${type.name}');
  
  return callApi(() => _apiService.searchPerson(
    
        identityCardNumber,
        type,
        
      ));
      
}*/
@override
Future<ApiResult<SearchPersonResponse?>> searchPersonById(
  String identityCardNumber, 
  PersonType type
) async {
  print('🔍 [1] بدء البحث عن الشخص - رقم الهوية: $identityCardNumber');
  print('📌 نوع الشخص: ${type.name}');
  
  try {
    final response = await _apiService.searchPerson(identityCardNumber, type);
    print('✅ [2] تم استلام الاستجابة من API بنجاح');
    print('📊 بيانات الاستجابة: ${response}');
    
    return ApiResult.success(response);
  } catch (e) {
    print('❌ [2] فشل في استدعاء API: ${e.toString()}');
    return ApiResult.failure(ErrorHandler.handle(e));
  }
}


  @override
  Future<ApiResult<void>> toggleActivation(
      PersonType type, String id, bool isActive) {
    return callApi(() => _apiService.toggleActivationPerson(
          type,
          id,
          {'is_active': isActive},
        ));
  }

 Future<ApiResult<(List<SimpleNationalityModel>, List<CityModel>)>>getNationalitiesAndCities(PersonType type) {
  print('📡 [Remote] بدء تحميل الجنسيات والمدن من الـ API');
  return callApi(() async {
    try {
      final response = await _apiService.getNationalitiesAndCities(type);
      print('✅ [Remote] الجنسيات والمدن: ${response.toJson()}');
      return (response.nationalities, response.cities);
    } catch (e, stack) {
      print('❌ [Remote] فشل تحميل الجنسيات والمدن: $e');
      rethrow;
    }
  });
}

Future<ApiResult<List<Map<String, dynamic>>>> getAreasByCity(PersonType type, String cityName) async {
  return callApi(() async {
    try {
      final List<Map<String, dynamic>> response = await _apiService.getAreasByCity(type, cityName);
      print('✅ [Remote] البيانات الخام: ${response.runtimeType} - $response');
      return response;
    } catch (e, stack) {
      print('❌ [Remote] خطأ في التحويل: ${e.runtimeType} - $e');
      throw (message: 'فشل تحميل المناطق: ${e.toString()}');
    }
  });
}
}

