import 'package:json_annotation/json_annotation.dart';

part 'nationality_model.g.dart';

@JsonSerializable()
class NationalityModel {
  final int id;
  final String nationality_name;
    final String country_name;
  final String country_code;

  NationalityModel({
    required this.id,
    required this.nationality_name,
    required this.country_name,
    required this.country_code,
  });

  factory NationalityModel.fromJson(Map<String, dynamic> json) =>
      _$NationalityModelFromJson(json);

  Map<String, dynamic> toJson() => _$NationalityModelToJson(this);
}
