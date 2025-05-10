import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

part 'mother_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MotherModel extends PersonModel {
  final bool isDeceased;
  final bool isActive;
  final int childCount;

  MotherModel({
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
    required this.isDeceased,
    required this.isActive,
    required this.childCount,
  }) : super(
          type: PersonType.father,
        );

  factory MotherModel.fromJson(Map<String, dynamic> json) =>
      _$MotherModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MotherModelToJson(this);
}
