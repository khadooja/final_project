import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

part 'father_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FatherModel extends PersonModel {
  final bool isDeceased;
  final bool isActive;
  final int childCount;

  FatherModel({
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

  factory FatherModel.fromJson(Map<String, dynamic> json) =>
      _$FatherModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FatherModelToJson(this);
}
