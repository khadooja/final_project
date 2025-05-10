import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/family_management/data/dataSources/fatherRemoteDataSource.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';

class FatherRemoteDataSourceImpl extends PersonRemoteDataSourceImpl
    implements FatherRemoteDataSource {
  final ApiServiceManual _api;

  FatherRemoteDataSourceImpl(this._api) : super(_api);

  @override
  Future<ApiResult<FatherModel>> addFather(FatherModel fatherModel) {
    return callApi(() async {
      return await _api.addFather(fatherModel);
    });
  }

  @override
  Future<ApiResult<FatherModel>> updateFather(String id, FatherModel model) {
    return callApi(() async {
      final person = await _api.updatePerson(
        PersonType.father,
        id,
        model.toJson(),
      );

      // هنا تأكد من نوع person إذا كان يحتوي على كل خصائص FatherModel
      final json = person.toJson();
      return FatherModel.fromJson(json);
    });
  }
}
