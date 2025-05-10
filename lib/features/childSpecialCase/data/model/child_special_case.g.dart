// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_special_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildSpecialCase _$ChildSpecialCaseFromJson(Map<String, dynamic> json) =>
    ChildSpecialCase(
      id: (json['id'] as num).toInt(),
      childId: (json['child_id'] as num).toInt(),
      specialCaseId: (json['special_case_id'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
    );

Map<String, dynamic> _$ChildSpecialCaseToJson(ChildSpecialCase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child_id': instance.childId,
      'special_case_id': instance.specialCaseId,
      'start_date': instance.startDate.toIso8601String(),
    };
