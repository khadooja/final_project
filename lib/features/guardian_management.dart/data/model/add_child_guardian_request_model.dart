import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';

part 'add_child_guardian_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AddChildGuardianRequestModel {
  final GurdianModel guardian;

  @JsonKey(name: 'relationship_type_id')
  final int relationshipTypesId;

  @JsonKey(name: 'relationship_start_date')
  final DateTime relationshipStartDate;

  @JsonKey(name: 'relationship_end_date')
  final DateTime relationshipEndDate;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'is_verified')
  final bool isVerified;

  @JsonKey(name: 'verification_document')
  final String? verificationDocument;

  final String? notes;

  @JsonKey(name: 'children_ids')
  final List<int> childrenIds;

  AddChildGuardianRequestModel({
    required this.guardian,
    required this.relationshipTypesId,
    required this.relationshipStartDate,
    required this.relationshipEndDate,
    required this.isActive,
    required this.isVerified,
    this.verificationDocument,
    this.notes,
    required this.childrenIds,
  });

  factory AddChildGuardianRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddChildGuardianRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddChildGuardianRequestModelToJson(this);
}
