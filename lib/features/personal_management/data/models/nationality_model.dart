import 'package:json_annotation/json_annotation.dart';

part 'nationality_model.g.dart';

@JsonSerializable()
class NationalityModel {
  final int id;
  final String name;

  NationalityModel({
    required this.id,
    required this.name,
  });

  factory NationalityModel.fromJson(Map<String, dynamic> json) =>
      _$NationalityModelFromJson(json);

  Map<String, dynamic> toJson() => _$NationalityModelToJson(this);
}
