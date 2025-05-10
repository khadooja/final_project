// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationshipTypeModel _$RelationshipTypeModelFromJson(
        Map<String, dynamic> json) =>
    RelationshipTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RelationshipTypeModelToJson(
        RelationshipTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
