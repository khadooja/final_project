import 'package:dio/dio.dart';
import 'package:new_project/Core/api/endpoints/child_endpoints.dart';
import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/config/api_config.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_data_source.dart';
import 'package:new_project/features/children_managment/data/model/CommonDropdownsChidModel.dart';
import 'package:new_project/features/children_managment/data/model/child_edit_details_model.dart';
import 'package:new_project/features/children_managment/data/model/child_list_response_model.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

class ChildRemoteDataSourceImpl extends PersonRemoteDataSourceImpl
    implements ChildRemoteDataSource {
  final ApiServiceManual _apiService;
  final ChildEndpoints _childEndpoints =
      ChildEndpoints(); // Instantiate your endpoints

  ChildRemoteDataSourceImpl(this._apiService) : super(_apiService);

  @override
  Future<ApiResult<void>> addChild(ChildModel childData) async {
    return callApi(() async {
      print("🌍 ChildRemoteDataSourceImpl: Adding child: $childData");
      await _apiService.addChild(childData);
    });
  }

  @override
  Future<ApiResult<void>> updateChild(
      String id, Map<String, dynamic> childData) async {
    try {
      final childModel = ChildModel.fromJson(childData);
      await _apiService.updateChild(id, childModel);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  @override
  Future<ApiResult<CommonDropdownsChidModel>> getNationalitiesAndCitiesandCases(
      PersonType type) async {
    try {
      print('🌍 ChildRemoteDataSourceImpl: Fetching data for type: $type');

      final result = await _apiService.getDropdownsData(type);

      return ApiResult.success(
        CommonDropdownsChidModel.fromJson(result as Map<String, dynamic>),
      );
    } catch (e) {
      print('❌ ChildRemoteDataSourceImpl error: $e');
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  //new
  // @override
  // Future<ApiResult<ChildListResponseModel>> getChildren() async {
  //   try {
  //     // Assumes _apiService.get() takes a path relative to its configured baseUrl
  //     // And ChildEndpoints.getChildren provides the full URL.
  //     String endpointPath = _childEndpoints.getChildren;
  //     if (endpointPath.startsWith(ApiConfig.baseUrl)) {
  //       endpointPath = endpointPath.substring(ApiConfig.baseUrl.length);
  //     }
  //     // Ensure path is clean (e.g. remove leading '/' if base URL ends with '/')
  //     if (ApiConfig.baseUrl.endsWith('/') && endpointPath.startsWith('/')) {
  //       endpointPath = endpointPath.substring(1);
  //     }

  //     // final response = await _apiService.get(_childEndpoints.getChildren); // If your service takes full URL
  //     final response = await _apiService
  //         .get(endpointPath); // If your service takes relative path
  //     final childListResponse =
  //         ChildListResponseModel.fromJson(response as Map<String, dynamic>);
  //     return ApiResult.success(childListResponse);
  //   } catch (e) {
  //     return ApiResult.failure(ErrorHandler.handle(e));
  //   }
  // }

  // @override
  // Future<ApiResult<ChildEditDetailsModel>> getChildDetailsById(
  //     String childId) async {
  //   try {
  //     // Use the endpoint that returns the detailed JSON for editing
  //     String path = _childEndpoints.getChildById(childId);
  //     // If your ApiServiceManual.get expects a relative path and Dio has baseUrl:
  //     if (path.startsWith(ApiConfig.baseUrl)) {
  //       path = path.substring(ApiConfig.baseUrl.length);
  //       if (ApiConfig.baseUrl.endsWith('/') && path.startsWith('/'))
  //         path = path.substring(1);
  //     }

  //     final responseData = await _apiService.get(path);
  //     if (responseData is Map<String, dynamic>) {
  //       final details = ChildEditDetailsModel.fromJson(responseData);
  //       return ApiResult.success(details);
  //     } else {
  //       return ApiResult.failure(
  //           ErrorHandler.handle("Invalid response format for child details."));
  //     }
  //   } catch (e) {
  //     return ApiResult.failure(ErrorHandler.handle(e));
  //   }
  // }

  // في ChildRemoteDataSourceImpl.dart

// ... (باقي الدوال) ...

  @override
  Future<ApiResult<ChildListResponseModel>> getChildren() async {
    try {
      // بما أن Dio مهيأ بـ baseUrl، و _childEndpoints.getChildren يُرجع المسار النسبي،
      // يمكنك استدعاء _apiService.get مباشرة بالمسار النسبي.
      final String relativePath =
          _childEndpoints.getChildren; // يجب أن تكون هذه الآن "children"
      print(
          "ChildRemoteDataSourceImpl: Calling _apiService.get with relative path: $relativePath");

      final response = await _apiService.get(relativePath);
      final childListResponse =
          ChildListResponseModel.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(childListResponse);
    } catch (e) {
      print("❌ ChildRemoteDataSourceImpl.getChildren error: $e");
      if (e is DioException) {
        print("DioError Response: ${e.response?.data}");
        print("DioError Request Options: ${e.requestOptions.uri}");
      }
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<ChildEditDetailsModel>> getChildDetailsById(
      String childId) async {
    try {
      final String relativePath = _childEndpoints
          .getChildById(childId); // يجب أن تُرجع "children/{childId}/edit"
      print(
          "ChildRemoteDataSourceImpl: Calling _apiService.get with relative path: $relativePath for ID: $childId");

      final responseData = await _apiService.get(relativePath);
      if (responseData is Map<String, dynamic>) {
        final details = ChildEditDetailsModel.fromJson(responseData);
        return ApiResult.success(details);
      } else {
        return ApiResult.failure(
            ErrorHandler.handle("Invalid response format for child details."));
      }
    } catch (e) {
      print(
          "❌ ChildRemoteDataSourceImpl.getChildDetailsById error: $e for ID: $childId");
      if (e is DioException) {
        print("DioError Response: ${e.response?.data}");
        print("DioError Request Options: ${e.requestOptions.uri}");
      }
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
