import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';

part 'employee_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeModel extends PersonModel {
  final String role;
  final DateTime? date_of_birth;
  final DateTime? employment_date;
  final int isActive;
  final int? health_center_id;

  EmployeeModel({
    super.id,
    required super.first_name,
    required super.last_name,
    required super.gender,
    required super.email,
    required super.phone_number,
    required super.identity_card_number,
    required super.nationalities_id,
    required super.location_id,
    required this.role,
    required this.date_of_birth,
    required this.employment_date,
    required this.isActive,
    required this.health_center_id,
  }) : super(
          isDeceased: false, // الموظف حي دائمًا عند الإنشاء
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  factory EmployeeModel.fromPerson(
    PersonModel person, {
    required String role,
    required DateTime employment_date,
    DateTime? date_of_birth,
    required int isActive,
    int? health_center_id,
  }) {
    return EmployeeModel(
      id: person.id,
      first_name: person.first_name,
      last_name: person.last_name,
      gender: person.gender,
      email: person.email,
      phone_number: person.phone_number,
      identity_card_number: person.identity_card_number,
      nationalities_id: person.nationalities_id,
      location_id: person.location_id,
      role: role,
      employment_date: employment_date,
      date_of_birth: date_of_birth,
      isActive: isActive,
      health_center_id: health_center_id,
    );
  }
factory EmployeeModel.fromCustomJson(Map<String, dynamic> json) {
  return EmployeeModel(
    id: json['Employee Id'] is int
        ? json['Employee Id']
        : int.tryParse(json['Employee Id']?.toString() ?? '0') ?? 0,
    first_name: json['First Name']?.toString() ?? '',
    last_name: json['Last Name']?.toString() ?? '',
    gender: json['Gender']?.toString() ?? '',
    email: json['Email']?.toString() ?? '',
    phone_number: json['Phone Number']?.toString() ?? '',
    identity_card_number: json['Identity Card Number']?.toString() ?? 'N/A',
    nationalities_id: json['Nationalities Id'] is int
        ? json['Nationalities Id']
        : int.tryParse(json['Nationalities Id']?.toString() ?? '0') ?? 0,
    location_id: json['Location Id'] is int
        ? json['Location Id']
        : int.tryParse(json['Location Id']?.toString() ?? ''),
    role: json['Position']?.toString() ?? 'موظف',
    date_of_birth: json['Date of Birth'] != null && json['Date of Birth'].toString().isNotEmpty
        ? DateTime.tryParse(json['Date of Birth'].toString())
        : null,
    employment_date: json['Employment Date'] != null && json['Employment Date'].toString().isNotEmpty
        ? DateTime.tryParse(json['Employment Date'].toString())
        : DateTime.now(),
    isActive: json['isActive'] is int
        ? json['isActive']
        : int.tryParse(json['isActive']?.toString() ?? '0') ?? 0,
    health_center_id: json['Health Center Id'] is int
        ? json['Health Center Id']
        : int.tryParse(json['Health Center Id']?.toString() ?? ''),
  );
}
}
