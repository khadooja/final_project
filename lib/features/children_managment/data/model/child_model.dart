import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/childSpecialCase/data/model/child_special_case.dart';

part 'child_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildModel {
  final int id;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'birth_date')
  final DateTime birthDate;
  final String gender;
  @JsonKey(name: 'father_id', includeIfNull: false)
  final int? fatherId;
  @JsonKey(name: 'mother_id', includeIfNull: false)
  final int? motherId;
  @JsonKey(name: 'nationality_id')
  final int nationalityId;
  @JsonKey(name: 'foreing_birth_country_id', includeIfNull: false)
  final int? foreignBirthCountryId;
  @JsonKey(name: 'special_cases', includeIfNull: false)
  final List<ChildSpecialCase>? specialCases;

  ChildModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    this.fatherId,
    this.motherId,
    required this.nationalityId,
    this.foreignBirthCountryId,
    this.specialCases,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildModelToJson(this);
}
