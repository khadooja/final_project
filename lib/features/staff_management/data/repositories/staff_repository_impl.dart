import 'package:dio/dio.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/data/datasources/staff_remote_data_source.dart';
import 'package:new_project/features/staff_management/data/model/employeeResponse.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PersonModel?> checkPersonExistence(String id) async {
    return await remoteDataSource.checkPersonExistence(id);
  }

  @override
  Future<bool> addNewEmployeeWithPerson(Map<String, dynamic> data) async {
    return await remoteDataSource.addEmployee(
      isPersonExist: false,
      data: data,
    );
  }

  @override
  Future<bool> addExistingPersonAsEmployee(
      int personId, Map<String, dynamic> employeeData) async {
    return await remoteDataSource.addEmployee(
      isPersonExist: true,
      data: {
        'personId': personId,
        ...employeeData,
      },
    );
  }

  @override
  Future<bool> updateEmployee(EmployeeModel employee) {
    return remoteDataSource.updateEmployee(EmployeeModel(
      id: employee.id,
      employmentDate: employee.employmentDate,
      dateOfBirth: employee.dateOfBirth,
      healthCenterId: employee.healthCenterId,
      isActive: employee.isActive,
    ));
  }

  @override
  Future<List<EmployeesResponse>> fetchEmployeesWithPagination() async {
    final List<dynamic> employeesJson = await remoteDataSource.fetchEmployees();
    return employeesJson
        .map((json) => EmployeesResponse.fromJson(json))
        .toList();
  }
  /*@override
Future<List<EmployeeModel>> fetchEmployeesWithPagination(int page, int limit) async {
  return await remoteDataSource.fetchEmployeesWithPagination(page, limit);
}*/

  @override
  Future<List<EmployeeModel>> fetchEmployees() async {
    try {
      final employees = await remoteDataSource.fetchEmployees();
      return employees;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Employees endpoint not found');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<bool> deactivateEmployee(String employeeId) {
    return remoteDataSource.deactivateEmployee(employeeId);
  }

  @override
  Future<Map<String, dynamic>> fetchDropdownData() async {
    final dropdownData = await remoteDataSource.fetchDropdownData();
    return dropdownData.toJson(); // assuming DropdownData has a toJson method
  }
}
