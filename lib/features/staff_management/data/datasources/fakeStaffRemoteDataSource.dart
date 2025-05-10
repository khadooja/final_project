import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class FakeAdminRemoteDataSource {
  List<EmployeeModel> employees = [
    EmployeeModel(
      id: 0,
      employmentDate: DateTime.now(),
      dateOfBirth: DateTime(1990, 1, 1),
      healthCenterId: 1,
      isActive: true,
      personData: PersonModel(
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
    ),
    EmployeeModel(
      id: 0,
      employmentDate: DateTime.now(),
      dateOfBirth: DateTime(1990, 1, 1),
      healthCenterId: 1,
      isActive: true,
      personData: PersonModel(
        id: 0,
        firstName: 'John',
        lastName: 'Doe',
        gender: 'male',
        email: 'john@example.com',
        phoneNumber: '123456789',
        identityCardNumber: '1234567890',
        nationalitiesId: 1,
        locationId: 1,
        birthDate: DateTime(1990, 1, 1),
      ),
    ),
    EmployeeModel(
      id: 0,
      employmentDate: DateTime.now(),
      dateOfBirth: DateTime(1990, 1, 1),
      healthCenterId: 1,
      isActive: true,
      personData: PersonModel(
        id: 0,
        firstName: 'John',
        lastName: 'Doe',
        gender: 'male',
        email: 'john@example.com',
        phoneNumber: '123456789',
        identityCardNumber: '1234567890',
        nationalitiesId: 1,
        locationId: 1,
        birthDate: DateTime(1990, 1, 1),
      ),
    )
  ];

  Future<List<EmployeeModel>> fetchEmployees() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print(
        "....................[FakeAdminRemoteDataSource]..........................................................................................");
    return employees;
  }

  Future<bool> addEmployee(EmployeeModel employee) async {
    await Future.delayed(const Duration(milliseconds: 300));
    employees.add(employee);
    return true;
  }

  Future<bool> updateEmployee(EmployeeModel updatedEmployee) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = employees.indexWhere((e) => e.id == updatedEmployee.id);
    if (index != -1) {
      employees[index] = updatedEmployee;
      return true;
    }
    return false;
  }

  Future<bool> deactivateEmployee(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      employees[index] = employees[index].copyWith(isActive: false);
      return true;
    }
    return false;
  }

  Future<EmployeeModel?> checkEmployeeExistence(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return employees.firstWhere(
        (e) => e.personData?.identityCardNumber == id,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchDropdownData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "healthCenters": [
        {
          "id": 1,
          "name": "المركز الرئيسي",
          "location_id": 1,
          "phone_number": "3333333333333"
        },
        {"id": 2, "name": "العيادة الشمالية"}
      ],
      "positions": [
        {"id": 1, "name": "طبيب عام"},
        {"id": 2, "name": "ممرض مسجل"}
      ],
      "nationalities": [
        {
          "id": 2,
          "countryName": "طبيب عام",
          "countryCode": "areas",
          "nationalityName": "streets"
        },
      ],
      "locations": [
        {"id": 1, "cities": "طبيب عام", "areas": "areas", "streets": "streets"},
        {"id": 2, "cities": "طبيب عام", "areas": "areas", "streets": "streets"},
      ]
    };
  }
}
