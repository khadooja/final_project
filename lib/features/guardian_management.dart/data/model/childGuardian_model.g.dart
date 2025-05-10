// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'childGuardian_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildGuardianModel _$ChildGuardianModelFromJson(Map<String, dynamic> json) =>
    ChildGuardianModel(
      json['startDate'] as String?,
      json['isActive'] as bool,
      json['isVerified'] as bool,
      json['verificationDocument'] as String?,
      (json['guardianId'] as num?)?.toInt(),
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      identityCardNumber: json['identityCardNumber'] as String,
      nationalitiesId: (json['nationalitiesId'] as num).toInt(),
      locationId: (json['locationId'] as num).toInt(),
      birthDate: DateTime.parse(json['birthDate'] as String),
      hasGuardian: json['hasGuardian'] as String,
      endDate: json['endDate'] as String,
      relationshipTypesId: (json['relationshipTypesId'] as num).toInt(),
      relationshipStartDate:
          DateTime.parse(json['relationshipStartDate'] as String),
      relationshipEndDate:
          DateTime.parse(json['relationshipEndDate'] as String),
      notes: json['notes'] as String?,
      childrenIds: (json['childrenIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ChildGuardianModelToJson(ChildGuardianModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'identityCardNumber': instance.identityCardNumber,
      'nationalitiesId': instance.nationalitiesId,
      'locationId': instance.locationId,
      'birthDate': instance.birthDate.toIso8601String(),
      'hasGuardian': instance.hasGuardian,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'verificationDocument': instance.verificationDocument,
      'relationshipTypesId': instance.relationshipTypesId,
      'relationshipStartDate': instance.relationshipStartDate.toIso8601String(),
      'relationshipEndDate': instance.relationshipEndDate.toIso8601String(),
      'notes': instance.notes,
      'childrenIds': instance.childrenIds,
      'guardianId': instance.guardianId,
    };
