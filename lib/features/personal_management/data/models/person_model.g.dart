// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonModel _$PersonModelFromJson(Map json) => PersonModel(
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
      type: $enumDecodeNullable(_$PersonTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$PersonModelToJson(PersonModel instance) =>
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
    };

const _$PersonTypeEnumMap = {
  PersonType.mother: 'mother',
  PersonType.father: 'father',
  PersonType.employee: 'employee',
  PersonType.guardian: 'guardian',
  PersonType.child: 'child',
};
