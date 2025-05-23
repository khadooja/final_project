import 'package:json_annotation/json_annotation.dart';

part 'area_model.g.dart';

@JsonSerializable()
class AreaModel {
  final int id;
  final String area_name;

  AreaModel({
    required this.id,
    required this.area_name,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) =>
      _$AreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AreaModelToJson(this);
}
