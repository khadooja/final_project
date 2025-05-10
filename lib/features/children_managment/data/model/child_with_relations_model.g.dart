// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_with_relations_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildWithRelationsModel _$ChildWithRelationsModelFromJson(
        Map<String, dynamic> json) =>
    ChildWithRelationsModel(
      child: ChildModel.fromJson(json['child'] as Map<String, dynamic>),
      specialCases: (json['specialCases'] as List<dynamic>?)
          ?.map((e) => SpecialCase.fromJson(e as Map<String, dynamic>))
          .toList(),
      countryModel: json['countryModel'] == null
          ? null
          : CountryModel.fromJson(json['countryModel'] as Map<String, dynamic>),
      nationality: NationalityModel.fromJson(
          json['nationality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChildWithRelationsModelToJson(
        ChildWithRelationsModel instance) =>
    <String, dynamic>{
      'child': instance.child.toJson(),
      'specialCases': instance.specialCases?.map((e) => e.toJson()).toList(),
      'countryModel': instance.countryModel?.toJson(),
      'nationality': instance.nationality.toJson(),
    };
