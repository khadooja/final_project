import 'package:dio/dio.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/data/model/dropdownclass.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class AdminRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  AdminRemoteDataSource({required this.dio, required this.baseUrl});

  Future<PersonModel?> checkPersonExistence(String nationalityId) async {
    try {
      final response = await dio.get('$baseUrl/Check_Id_card/$nationalityId');
      if (response.statusCode == 200) {
        return PersonModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception('Failed to check person existence: ${e.message}');
    }
  }

  Future<bool> addEmployee({
    required bool isPersonExist,
    required Map<String, dynamic> data,
  }) async {
    try {
      final endpoint = isPersonExist ? 'Employee/existing' : 'Employee/new';
      final response = await dio.post(
        '$baseUrl/$endpoint',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Failed to add employee: ${e.message}');
    }
  }

  Future<List<EmployeeModel>> fetchEmployeesWithPagination(
      int page, int limit) async {
    try {
      final response = await dio.get(
        '$baseUrl/employees',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => EmployeeModel.fromJson(json))
            .toList();
      }
      throw Exception('Failed to fetch employees');
    } on DioException catch (e) {
      throw Exception('Failed to fetch employees: ${e.message}');
    }
  }

  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await dio.get('$baseUrl/employees');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => EmployeeModel.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load employees');
  }

  Future<DropdownData> fetchDropdownData() async {
    try {
      final response = await dio.get('$baseUrl/dropdown-data');
      if (response.statusCode == 200) {
        return DropdownData.fromJson(response.data);
      }
      throw Exception('Failed to load dropdown data');
    } on DioException catch (e) {
      throw Exception('Dropdown data error: ${e.message}');
    }
  }

  Future<bool> updateEmployee(EmployeeModel employee) async {
    try {
      final response = await dio.put(
        '$baseUrl/employee/${employee.id}',
        data: employee.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to update employee: ${e.message}');
    }
  }

  Future<bool> deactivateEmployee(String employeeId) async {
    try {
      final response = await dio.patch(
        '$baseUrl/employee/$employeeId/deactivate',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to deactivate employee: ${e.message}');
    }
  }
}
