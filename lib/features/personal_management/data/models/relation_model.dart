import 'package:json_annotation/json_annotation.dart';

part 'relation_model.g.dart';

@JsonSerializable()
class RelationModel {
  final int id;
  final String name;

  RelationModel({
    required this.id,
    required this.name,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) =>
      _$RelationModelFromJson(json);

  Map<String, dynamic> toJson() => _$RelationModelToJson(this);
}
