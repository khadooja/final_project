import 'package:json_annotation/json_annotation.dart';

part 'child_special_case.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildSpecialCase {
  final int id;
  @JsonKey(name: 'child_id')
  final int childId;
  @JsonKey(name: 'special_case_id')
  final int specialCaseId;
  @JsonKey(name: 'start_date')
  final DateTime startDate;

  ChildSpecialCase({
    required this.id,
    required this.childId,
    required this.specialCaseId,
    required this.startDate,
  });

  factory ChildSpecialCase.fromJson(Map<String, dynamic> json) =>
      _$ChildSpecialCaseFromJson(json);

  Map<String, dynamic> toJson() => _$ChildSpecialCaseToJson(this);
}
