import 'package:json_annotation/json_annotation.dart';

part 'special_case.g.dart';

@JsonSerializable(explicitToJson: true)
class SpecialCase {
  final int id;
  final String caseName;
  final String description;

  SpecialCase({
    required this.id,
    required this.caseName,
    required this.description,
  });

  factory SpecialCase.fromJson(Map<String, dynamic> json) =>
      _$SpecialCaseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialCaseToJson(this);
}
