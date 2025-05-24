// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
