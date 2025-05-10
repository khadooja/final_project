import 'package:json_annotation/json_annotation.dart';
part 'relationship_type_model.g.dart';

@JsonSerializable()
class RelationshipTypeModel {
  final int id;
  final String name;

  RelationshipTypeModel({
    required this.id,
    required this.name,
  });

  factory RelationshipTypeModel.fromJson(Map<String, dynamic> json) =>
      _$RelationshipTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipTypeModelToJson(this);
}
