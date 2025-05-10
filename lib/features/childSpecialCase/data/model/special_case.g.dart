// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialCase _$SpecialCaseFromJson(Map<String, dynamic> json) => SpecialCase(
      id: (json['id'] as num).toInt(),
      caseName: json['caseName'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$SpecialCaseToJson(SpecialCase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caseName': instance.caseName,
      'description': instance.description,
    };
