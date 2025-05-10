import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/data/datasources/fakeStaffRemoteDataSource.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/data/model/employeeResponse.dart';
import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';

class MockAdminRemoteDataSource implements AdminRepository {
  final FakeAdminRemoteDataSource remoteDataSource;
  final List<EmployeeModel> _fakeEmployees = [];
  final List<PersonModel> _fakePersons = [];

  MockAdminRemoteDataSource({required this.remoteDataSource}) {
    // Initialize with some fake data
    _fakePersons.addAll([
      PersonModel(
        id: 1,
        firstName: "محمد",
        lastName: "علي",
        gender: "ذكر",
        email: "mohamed@example.com",
        phoneNumber: "123456789",
        identityCardNumber: "1234567890",
        nationalitiesId: 1,
        locationId: 1,
        birthDate: DateTime(1985, 5, 15),
      ),
      PersonModel(
        id: 2,
        firstName: "فاطمة",
        lastName: "أحمد",
        gender: "أنثى",
        email: "fatima@example.com",
        phoneNumber: "987654321",
        identityCardNumber: "0987654321",
        nationalitiesId: 1,
        locationId: 2,
        birthDate: DateTime(1990, 10, 20),
      ),
    ]);

    _fakeEmployees.addAll([
      EmployeeModel(
        id: 1,
        employmentDate: DateTime(2020, 1, 1),
        dateOfBirth: DateTime(1980, 1, 1),
        healthCenterId: 1,
        isActive: true,
        personData: _fakePersons[0],
      ),
      EmployeeModel(
        id: 2,
        employmentDate: DateTime(2021, 1, 1),
        dateOfBirth: DateTime(1990, 1, 1),
        healthCenterId: 1,
        isActive: true,
        personData: _fakePersons[1],
      ),
    ]);
  }

  @override
  Future<PersonModel?> checkPersonExistence(String id) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return _fakePersons.firstWhere(
      (person) => person.identityCardNumber == id,
      // orElse: () => null,
    );
  }

  @override
  Future<bool> addNewEmployeeWithPerson(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newPerson = PersonModel(
      id: _fakePersons.length + 1,
      firstName: data['first_name'],
      lastName: data['last_name'],
      gender: data['gender'],
      email: data['email'],
      phoneNumber: data['phone_number'],
      identityCardNumber: data['identity_card_number'],
      nationalitiesId: data['nationalities_id'],
      locationId: data['location_id'],
      birthDate: data['birth_date'] ?? DateTime.now().toString(),
    );

    final newEmployee = EmployeeModel(
      id: _fakeEmployees.length + 1,
      employmentDate: DateTime.parse(data['employment_date']),
      dateOfBirth: DateTime.parse(data['date_of_birth']),
      healthCenterId: data['health_center_id'],
      isActive: true,
      personData: newPerson,
    );

    _fakePersons.add(newPerson);
    _fakeEmployees.add(newEmployee);

    return true;
  }

  @override
  Future<bool> addExistingPersonAsEmployee(
      int personId, Map<String, dynamic> employeeData) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final person = _fakePersons.firstWhere((p) => p.id == personId);

    final newEmployee = EmployeeModel(
      id: _fakeEmployees.length + 1,
      employmentDate: DateTime.parse(employeeData['employment_date']),
      dateOfBirth: DateTime.parse(employeeData['date_of_birth']),
      healthCenterId: employeeData['health_center_id'],
      isActive: true,
      personData: person,
    );

    _fakeEmployees.add(newEmployee);

    return true;
  }

  @override
  Future<bool> updateEmployee(EmployeeModel employee) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _fakeEmployees.indexWhere((e) => e.id == employee.id);
    if (index != -1) {
      _fakeEmployees[index] = EmployeeModel(
        id: employee.id,
        employmentDate: employee.employmentDate,
        dateOfBirth: employee.dateOfBirth,
        healthCenterId: employee.healthCenterId,
        isActive: employee.isActive,
        personData: employee.personData, // استخدام مباشر بدون تحويل
      );
      return true;
    }
    return false;
  }

  @override
  Future<List<EmployeesResponse>> fetchEmployeesWithPagination() async {
    await Future.delayed(const Duration(milliseconds: 500));

    const employeesPerPage = 10;
    final totalPages = (_fakeEmployees.length / employeesPerPage).ceil();

    return [
      EmployeesResponse(
        employees: _fakeEmployees,
        totalEmployees: _fakeEmployees.length,
        currentPage: 1,
        totalPages: totalPages,
      ),
    ];
  }

  @override
  Future<List<EmployeeModel>> fetchEmployees() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _fakeEmployees;
  }

  @override
  Future<bool> deactivateEmployee(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index =
        _fakeEmployees.indexWhere((e) => e.id == int.parse(employeeId));
    if (index != -1) {
      _fakeEmployees[index] = _fakeEmployees[index].copyWith(isActive: false);
      return true;
    }
    return false;
  }

  @override
  Future<Map<String, dynamic>> fetchDropdownData() async {
    try {
      final data = await remoteDataSource.fetchDropdownData();
      return data;
    } catch (e) {
      throw Exception('Failed to fetch dropdown data: $e');
    }
  }
}
