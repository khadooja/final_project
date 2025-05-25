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

// @override
//   Future<ApiResult<ChildListResponseModel>> getChildren() async {
//     try {
//       // Assumes _apiService.get() takes a path relative to its configured baseUrl
//       // And ChildEndpoints.getChildren provides the full URL.
//       String endpointPath = _childEndpoints.getChildren;
//       if (endpointPath.startsWith(ApiConfig.baseUrl)) {
//         endpointPath = endpointPath.substring(ApiConfig.baseUrl.length);
//       }
//       // Ensure path is clean (e.g. remove leading '/' if base URL ends with '/')
//        if (ApiConfig.baseUrl.endsWith('/') && endpointPath.startsWith('/')) {
//          endpointPath = endpointPath.substring(1);
//        }

//       // final response = await _apiService.get(_childEndpoints.getChildren); // If your service takes full URL
//       final response = await _apiService.get(endpointPath); // If your service takes relative path
//       final childListResponse = ChildListResponseModel.fromJson(response as Map<String, dynamic>);
//       return ApiResult.success(childListResponse);
//     } catch (e) {
//       return ApiResult.failure(ErrorHandler.handle(e));
//     }
//   }
// In ChildRemoteDataSourceImpl
  @override
  Future<ApiResult<ChildListResponseModel>> getChildren() async {
    try {
      // Original logic for endpointPath
      String endpointPath = _childEndpoints.getChildById;
      if (ApiConfig.baseUrl.isNotEmpty &&
          endpointPath.startsWith(ApiConfig.baseUrl)) {
        // This logic is for when Dio has a baseUrl and endpointPath is full
        endpointPath = endpointPath.substring(ApiConfig.baseUrl.length);
        if (ApiConfig.baseUrl.endsWith('/') && endpointPath.startsWith('/')) {
          endpointPath = endpointPath.substring(1);
        } else if (!ApiConfig.baseUrl.endsWith('/') &&
            !endpointPath.startsWith('/') &&
            !Uri.parse(endpointPath).isAbsolute) {
          endpointPath = '/$endpointPath';
        }
      } else if (ApiConfig.baseUrl.isEmpty &&
          !Uri.parse(endpointPath).isAbsolute) {
        // This case should not happen if ChildEndpoints provides full URL or relative with a configured base
        print(
            "Error: Dio baseUrl is empty, and endpointPath is not absolute: $endpointPath");
        // Potentially throw an error or handle
      }

      print(
          '🌍 ChildRemoteDataSourceImpl: Making GET request to endpointPath: "$endpointPath"');
      print(
          '🌍 Dio base URL is: "${_apiService.getDioBaseUrl()}"'); // Add a helper in ApiServiceManual to get this
      final responseData = await _apiService.get(endpointPath);

      if (responseData is Map<String, dynamic>) {
        final childListResponse = ChildListResponseModel.fromJson(responseData);
        return ApiResult.success(childListResponse);
      } else {
        return ApiResult.failure(ErrorHandler.handle(
            "Invalid response format: Expected Map, got ${responseData.runtimeType}"));
      }
    } catch (e) {
      print('❌ ChildRemoteDataSourceImpl getChildren error: $e');
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
  // @override
  // Future<ApiResult<ChildListResponseModel>> getChildren() async {
  //   try {
  //     String endpointPath = _childEndpoints.getChildren;
  //     // Remove base URL if it's prefixed, to pass only the relative path
  //     if (endpointPath.startsWith(ApiConfig.baseUrl)) {
  //       endpointPath = endpointPath.substring(ApiConfig.baseUrl.length);
  //     }
  //     // Ensure path is clean (e.g. remove leading '/' if base URL ends with '/')
  //     if (ApiConfig.baseUrl.endsWith('/') && endpointPath.startsWith('/')) {
  //       endpointPath = endpointPath.substring(1);
  //     } else if (!ApiConfig.baseUrl.endsWith('/') &&
  //         !endpointPath.startsWith('/')) {
  //       // If Dio's baseUrl doesn't end with / and path doesn't start with /
  //       // and it's not an absolute URL already
  //       if (!Uri.parse(endpointPath).isAbsolute) {
  //         endpointPath = '/$endpointPath';
  //       }
  //     }

  //     final responseData =
  //         await _apiService.get(endpointPath); // Pass relative path

  //     if (responseData is Map<String, dynamic>) {
  //       final childListResponse = ChildListResponseModel.fromJson(responseData);
  //       return ApiResult.success(childListResponse);
  //     } else {
  //       return ApiResult.failure(ErrorHandler.handle(
  //           "Invalid response format: Expected Map, got ${responseData.runtimeType}"));
  //     }
  //   } catch (e) {
  //     return ApiResult.failure(ErrorHandler.handle(e));
  //   }
  // }

  @override
  Future<ApiResult<void>> addChild(Map<String, dynamic> childData) async {
    try {
      final childModel = ChildModel.fromJson(childData);
      await _apiService.addChild(childModel);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
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
  Future<ApiResult<CommonDropdownsChidModel>> getNationalitiesAndCitiesandCases(
      PersonType type) async {
    try {
      final result = await _apiService.getRelationshipTypes();
      //final result = await _apiService.getNationalitiesAndCitiesUseCase(type);
      return ApiResult.success(
          CommonDropdownsChidModel.fromJson(result as Map<String, dynamic>));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<ChildEditDetailsModel>> getChildDetailsById(String childId) {
    // TODO: implement getChildDetailsById
    throw UnimplementedError();
  }
}
