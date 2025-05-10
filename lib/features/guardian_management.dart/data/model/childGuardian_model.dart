import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

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
  final bool isDeceased; // مخفي عن JSON لأنه موجود في PersonModel

  ChildGuardianModel(
    this.startDate,
    this.isActive,
    this.isVerified,
    this.verificationDocument,
    this.guardianId, {
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.email,
    required super.phoneNumber,
    required super.identityCardNumber,
    required super.nationalitiesId,
    required super.locationId,
    required super.birthDate,
    required this.hasGuardian,
    required this.endDate,
    required this.relationshipTypesId,
    required this.relationshipStartDate,
    required this.relationshipEndDate,
    this.notes,
    required this.childrenIds,
    this.isDeceased = false,
  }) : super(
          type: PersonType.guardian,
        );

  factory ChildGuardianModel.fromJson(Map<String, dynamic> json) =>
      _$ChildGuardianModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChildGuardianModelToJson(this);
}
