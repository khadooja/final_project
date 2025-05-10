// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_child_guardian_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChildGuardianRequestModel _$AddChildGuardianRequestModelFromJson(
        Map<String, dynamic> json) =>
    AddChildGuardianRequestModel(
      guardian: GurdianModel.fromJson(json['guardian'] as Map<String, dynamic>),
      relationshipTypesId: (json['relationship_type_id'] as num).toInt(),
      relationshipStartDate:
          DateTime.parse(json['relationship_start_date'] as String),
      relationshipEndDate:
          DateTime.parse(json['relationship_end_date'] as String),
      isActive: json['is_active'] as bool,
      isVerified: json['is_verified'] as bool,
      verificationDocument: json['verification_document'] as String?,
      notes: json['notes'] as String?,
      childrenIds: (json['children_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AddChildGuardianRequestModelToJson(
        AddChildGuardianRequestModel instance) =>
    <String, dynamic>{
      'guardian': instance.guardian.toJson(),
      'relationship_type_id': instance.relationshipTypesId,
      'relationship_start_date':
          instance.relationshipStartDate.toIso8601String(),
      'relationship_end_date': instance.relationshipEndDate.toIso8601String(),
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      'verification_document': instance.verificationDocument,
      'notes': instance.notes,
      'children_ids': instance.childrenIds,
    };
