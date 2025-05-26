import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_data_source.dart';
import 'package:new_project/features/children_managment/data/model/CommonDropdownsChidModel.dart';
import 'package:new_project/features/children_managment/data/model/child_edit_details_model.dart';
import 'package:new_project/features/children_managment/data/model/child_list_response_model.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

class ChildRepositoryImpl implements ChildRepository {
  final ChildRemoteDataSource _remoteDataSource;

  ChildRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<ChildListResponseModel>> getChildren() {
    return _remoteDataSource.getChildren();
  }

  @override
  Future<ApiResult<void>> addChild( ChildModel childData) {
    print(" Repository Adding child: $childData");
    return _remoteDataSource.addChild(childData);
  }

  @override
  Future<ApiResult<ChildEditDetailsModel>> getChildDetailsById(String childId) {
    return _remoteDataSource.getChildDetailsById(childId);
  }

  @override
  Future<ApiResult<void>> updateChild(
      String id, Map<String, dynamic> childData) {
    return _remoteDataSource.updateChild(id, childData);
  }

  @override
  Future<ApiResult<CommonDropdownsChidModel>>
      getNationalitiesAndCitiesandCases() {
  print("Fetching nationalities, cities, and cases for children");
    return _remoteDataSource
        .getNationalitiesAndCitiesandCases(PersonType.child);
  }

  @override
  Future<ApiResult<PersonModel?>> searchParentById(PersonType type, String id) {
    // TODO: implement searchParentById
    throw UnimplementedError();
  }
}
