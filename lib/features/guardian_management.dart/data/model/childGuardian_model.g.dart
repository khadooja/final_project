// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'childGuardian_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildGuardianModel _$ChildGuardianModelFromJson(Map<String, dynamic> json) =>
    ChildGuardianModel(
      id: (json['id'] as num?)?.toInt(),
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String?,
      phone_number: json['phone_number'] as String?,
      identity_card_number: json['identity_card_number'] as String,
      nationalities_id: (json['nationalities_id'] as num).toInt(),
      location_id: (json['location_id'] as num?)?.toInt(),
      hasGuardian: json['hasGuardian'] as String,
      endDate: json['endDate'] as String,
      startDate: json['startDate'] as String?,
      isActive: json['isActive'] as bool,
      isVerified: json['isVerified'] as bool,
      verificationDocument: json['verificationDocument'] as String?,
      relationshipTypesId: (json['relationshipTypesId'] as num).toInt(),
      relationshipStartDate:
          DateTime.parse(json['relationshipStartDate'] as String),
      relationshipEndDate:
          DateTime.parse(json['relationshipEndDate'] as String),
      notes: json['notes'] as String?,
      childrenIds: (json['childrenIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      guardianId: (json['guardianId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChildGuardianModelToJson(ChildGuardianModel instance) =>
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
