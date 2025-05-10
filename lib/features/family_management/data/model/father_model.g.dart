// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'father_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FatherModel _$FatherModelFromJson(Map<String, dynamic> json) => FatherModel(
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
      isDeceased: json['isDeceased'] as bool,
      isActive: json['isActive'] as bool,
      childCount: (json['childCount'] as num).toInt(),
    );

Map<String, dynamic> _$FatherModelToJson(FatherModel instance) =>
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
      'isDeceased': instance.isDeceased,
      'isActive': instance.isActive,
      'childCount': instance.childCount,
    };
