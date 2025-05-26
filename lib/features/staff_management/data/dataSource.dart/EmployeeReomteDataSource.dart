import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';
import 'package:new_project/features/staff_management/data/dataSource.dart/EmployeeRemoteDataSource.dart';
import 'package:new_project/features/staff_management/data/model/CreateEmployeeDataModel.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class EmployeeRemoteDataSourceImpl extends PersonRemoteDataSourceImpl
    implements EmployeeRemoteDataSource {
  final ApiServiceManual _api;

  EmployeeRemoteDataSourceImpl(this._api) : super(_api);

  @override
  Future<ApiResult<EmployeeModel>> addEmployee(EmployeeModel EmployeeModel) {
    return callApi(() async {
      return await _api.addEmployee(EmployeeModel);
    });
  }

  @override
  Future<ApiResult<EmployeeModel>> updateEmployee(
      String id, EmployeeModel model) {
    return callApi(() async {
      final person = await _api.updatePerson(
        PersonType.employee,
        id,
        model.toJson(),
      );

      // هنا تأكد من نوع person إذا كان يحتوي على كل خصائص EmployeeModel
      final json = person.toJson();
      return EmployeeModel.fromJson(json);
    });
  }

  @override
  Future<ApiResult<CreateEmployeeDataModel>> fetchCreateEmployeeData() {
    return callApi(() async {
      final result = await _api.fetchCreateEmployeeData();
      return result;
    });
  }
}
