// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gurdian_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GurdianModel _$GurdianModelFromJson(Map<String, dynamic> json) => GurdianModel(
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
      notes: json['notes'] as String?,
      childCount: (json['child_count'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$GurdianModelToJson(GurdianModel instance) =>
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
      'notes': instance.notes,
      'child_count': instance.childCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'isActive': instance.isActive,
    };
