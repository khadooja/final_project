import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';

class GuardianRemoteDataSourceImpl extends PersonRemoteDataSourceImpl
    implements GuardianRemoteDataSource {
  final ApiServiceManual _api;

  GuardianRemoteDataSourceImpl(this._api) : super(_api);

  @override
  Future<ApiResult<GurdianModel>> addGuardian(GurdianModel guardianModel) {
    return callApi(() async {
      return await _api.addGuardian(guardianModel);
    });
  }

  @override
  Future<ApiResult<GurdianModel>> updateGuardian(
      String id, GurdianModel model) {
    return callApi(() async {
      final response = await _api.updatePerson(
        PersonType.guardian,
        id,
        model.toJson(),
      );

      return GurdianModel.fromJson(response.toJson());
    });
  }
}
