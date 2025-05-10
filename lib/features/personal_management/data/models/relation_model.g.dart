// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationModel _$RelationModelFromJson(Map<String, dynamic> json) =>
    RelationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RelationModelToJson(RelationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
