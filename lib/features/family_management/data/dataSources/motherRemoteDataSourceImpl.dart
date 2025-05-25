import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/family_management/data/dataSources/motherRemoteDataSource.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';

class MotherRemoteDataSourceImpl extends PersonRemoteDataSourceImpl
    implements MotherRemoteDataSource {
  final ApiServiceManual _api;

  MotherRemoteDataSourceImpl(this._api) : super(_api);

  @override
  Future<ApiResult<MotherModel>> addMother(MotherModel motherModel) {
    return callApi(() async {
      return await _api.addMother(motherModel);
    });
  }

  @override
  Future<ApiResult<MotherModel>> updateMother(String id, MotherModel model) {
    return callApi(() async {
      final person = await _api.updatePerson(
        PersonType.father,
        id,
        model.toJson(),
      );

      final json = person.toJson();
      return MotherModel.fromJson(json);
    });
  }
}
