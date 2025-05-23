// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'father_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FatherModel _$FatherModelFromJson(Map<String, dynamic> json) => FatherModel(
      id: (json['id'] as num).toInt(),
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String?,
      phone_number: json['phone_number'] as String?,
      identity_card_number: json['identity_card_number'] as String,
      nationalities_id: (json['nationalities_id'] as num).toInt(),
      location_id: (json['location_id'] as num?)?.toInt(),
      birthDate: DateTime.parse(json['birthDate'] as String),
      isDeceased: json['isDeceased'] as bool,
      isActive: json['isActive'] as bool,
      childCount: (json['childCount'] as num).toInt(),
    );

Map<String, dynamic> _$FatherModelToJson(FatherModel instance) =>
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
      'isDeceased': instance.isDeceased,
      'isActive': instance.isActive,
      'childCount': instance.childCount,
      'birthDate': instance.birthDate.toIso8601String(),
    };
