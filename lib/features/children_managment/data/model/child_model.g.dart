// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildModel _$ChildModelFromJson(Map<String, dynamic> json) => ChildModel(
      id: (json['id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String,
      fatherId: (json['father_id'] as num?)?.toInt(),
      motherId: (json['mother_id'] as num?)?.toInt(),
      nationalityId: (json['nationality_id'] as num).toInt(),
      foreignBirthCountryId:
          (json['foreing_birth_country_id'] as num?)?.toInt(),
      specialCases: (json['special_cases'] as List<dynamic>?)
          ?.map((e) => ChildSpecialCase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChildModelToJson(ChildModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'birth_date': instance.birthDate.toIso8601String(),
      'gender': instance.gender,
      if (instance.fatherId case final value?) 'father_id': value,
      if (instance.motherId case final value?) 'mother_id': value,
      'nationality_id': instance.nationalityId,
      if (instance.foreignBirthCountryId case final value?)
        'foreing_birth_country_id': value,
      if (instance.specialCases?.map((e) => e.toJson()).toList()
          case final value?)
        'special_cases': value,
    };
