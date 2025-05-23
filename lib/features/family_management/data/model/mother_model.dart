import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/staff_management/data/model/dropdownclass.dart';

part 'mother_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MotherModel extends PersonModel {
  final bool isDeceased;
  final bool isActive;
  final int childCount;
  final DateTime? birthDate;

  MotherModel({


    required super.id,
    required super.first_name,
    required super.last_name,
    required super.gender,
    required super.email,
    required super.phone_number,
    required super.identity_card_number,
    required super.nationalities_id,
    required super.location_id,
    required this.birthDate,
    required this.isDeceased,
    required this.isActive,
    required this.childCount,
  }) : super(
          isDeceased: isDeceased,
          // type: PersonType.mother,
          // location: location,
        );

  factory MotherModel.fromJson(Map<String, dynamic> json) =>
      _$MotherModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MotherModelToJson(this);
}
