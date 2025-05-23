import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';

part 'childGuardian_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildGuardianModel extends PersonModel {
  final String hasGuardian;
  final String endDate;
  final String? startDate;
  final bool isActive;
  final bool isVerified;
  final String? verificationDocument;
  final int relationshipTypesId;
  final DateTime relationshipStartDate;
  final DateTime relationshipEndDate;
  final String? notes;
  final List<int> childrenIds;
  final int? guardianId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isDeceased;

  ChildGuardianModel({
    required super.id,
    required super.first_name,
    required super.last_name,
    required super.gender,
    required super.email,
    required super.phone_number,
    required super.identity_card_number,
    required super.nationalities_id,
    required super.location_id,
    required this.hasGuardian,
    required this.endDate,
    this.startDate,
    required this.isActive,
    required this.isVerified,
    this.verificationDocument,
    required this.relationshipTypesId,
    required this.relationshipStartDate,
    required this.relationshipEndDate,
    this.notes,
    required this.childrenIds,
    this.guardianId,
    this.isDeceased = false,
  }) : super(isDeceased: false);

  factory ChildGuardianModel.fromJson(Map<String, dynamic> json) =>
      _$ChildGuardianModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChildGuardianModelToJson(this);
}