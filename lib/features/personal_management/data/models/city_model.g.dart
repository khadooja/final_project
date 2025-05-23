// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
      id: (json['id'] as num).toInt(),
      city_name: json['city_name'] as String,
    );

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
      'id': instance.id,
      'city_name': instance.city_name,
    };
