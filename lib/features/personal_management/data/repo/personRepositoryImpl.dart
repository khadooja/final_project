import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';
import 'package:new_project/features/personal_management/data/models/SimpleNationalityModel.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource _remoteDataSource;

  PersonRepositoryImpl(this._remoteDataSource);

 /* @override
Future<ApiResult<SearchPersonResponse?>> searchPersonById(String identityCardNumber, PersonType type) {
  return _remoteDataSource.searchPersonById(
    identityCardNumber,
    type,
  );
}*/
@override
Future<ApiResult<SearchPersonResponse?>> searchPersonById(
  String identityCardNumber,
  PersonType type,
) async {
  print('🔄 [3] جاري تحويل الطلب إلى DataSource');
  final result = await _remoteDataSource.searchPersonById(identityCardNumber, type);
  
  result.when(
    success: (data) {
      if (data == null) {
        print('⚠️ [3.1] الاستجابة فارغة من السيرفر');
      } else {
        print('✔ [3.1] تم تحويل البيانات بنجاح');
        print('👤 بيانات الشخص: ${data.data?.person?.toJson()}');
        print('👨‍👦 بيانات الأب: ${data.data?.father?.toJson()}');
      }
    },
    failure: (error) {
      print('❌ [3.1] خطأ في DataSource: ${error.message}');
    },
  );
  
  return result;
}

  @override
  Future<ApiResult<void>> toggleActivation(
      PersonType type, String id, bool isActive) {
    return _remoteDataSource.toggleActivation(type, id, isActive);
  }

  
  @override
  Future<ApiResult<(List<SimpleNationalityModel>, List<CityModel>)>>
      getNationalitiesAndCities(PersonType type) {
    print('🔄 [Repo] تحويل الطلب إلى RemoteDataSource');
    return _remoteDataSource.getNationalitiesAndCities(type);
  }

  @override
  Future<ApiResult<List<AreaModel>>> getAreasByCity(
      PersonType type, String cityName) {
    print('🔄 [Repo] تحويل الطلب إلى RemoteDataSource');
    return _remoteDataSource.getAreasByCity(type, cityName);
  }
}
