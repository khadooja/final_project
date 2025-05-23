// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nationality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NationalityModel _$NationalityModelFromJson(Map<String, dynamic> json) =>
    NationalityModel(
      id: (json['id'] as num).toInt(),
      nationality_name: json['nationality_name'] as String,
      country_name: json['country_name'] as String,
      country_code: json['country_code'] as String,
    );

Map<String, dynamic> _$NationalityModelToJson(NationalityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nationality_name': instance.nationality_name,
      'country_name': instance.country_name,
      'country_code': instance.country_code,
    };
