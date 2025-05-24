// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonModel _$PersonModelFromJson(Map<String, dynamic> json) => PersonModel(
      id: (json['id'] as num).toInt(),
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String?,
      phone_number: json['phone_number'] as String?,
      identity_card_number: json['identity_card_number'] as String,
      isDeceased: json['isDeceased'] as bool,
      nationalities_id: (json['nationalities_id'] as num).toInt(),
      location_id: (json['location_id'] as num?)?.toInt(),
      location: json['location'] == null
          ? null
          : AreaModel.fromJson(json['location'] as Map<String, dynamic>),
      nationality: json['nationality'] == null
          ? null
          : NationalityModel.fromJson(
              json['nationality'] as Map<String, dynamic>),
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$PersonModelToJson(PersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'gender': instance.gender,
      'email': instance.email,
      'phone_number': instance.phone_number,
      'identity_card_number': instance.identity_card_number,
      'isDeceased': instance.isDeceased,
      'nationalities_id': instance.nationalities_id,
      'location_id': instance.location_id,
      'birthDate': instance.birthDate?.toIso8601String(),
      'location': instance.location,
      'nationality': instance.nationality,
    };
