// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      id: (json['id'] as num?)?.toInt(),
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String?,
      phone_number: json['phone_number'] as String?,
      identity_card_number: json['identity_card_number'] as String,
      nationalities_id: (json['nationalities_id'] as num).toInt(),
      location_id: (json['location_id'] as num?)?.toInt(),
      role: json['role'] as String,
      date_of_birth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      employment_date: DateTime.parse(json['employment_date'] as String),
      isActive: (json['isActive'] as num).toInt(),
      health_center_id: (json['health_center_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'gender': instance.gender,
      'email': instance.email,
      'phone_number': instance.phone_number,
      'identity_card_number': instance.identity_card_number,
      'nationalities_id': instance.nationalities_id,
      'location_id': instance.location_id,
      'role': instance.role,
      'date_of_birth': instance.date_of_birth?.toIso8601String(),
      'employment_date': instance.employment_date?.toIso8601String(),
      'isActive': instance.isActive,
      'health_center_id': instance.health_center_id,
    };
