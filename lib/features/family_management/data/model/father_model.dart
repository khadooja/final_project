import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/data/model/dropdownclass.dart';

part 'father_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FatherModel extends PersonModel {
  final bool isDeceased;
  final bool is_Active;
  final int child_Count;
  final DateTime birthDate;


  FatherModel({
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
    required this.is_Active,
    required this.child_Count,
  }) : super(
    isDeceased: isDeceased,
         // type: PersonType.father,
        );

  factory FatherModel.fromJson(Map<String, dynamic> json) =>
      _$FatherModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FatherModelToJson(this);

  factory FatherModel.fromPerson(PersonModel person) {
    return FatherModel(
      id: person.id,
      first_name: person.first_name,
      last_name: person.last_name,
      gender: person.gender,
      email: person.email,
      phone_number: person.phone_number,
      identity_card_number: person.identity_card_number,
      nationalities_id: person.nationalities_id,
      location_id: person.location_id,
      birthDate: person.birthDate ?? DateTime.now(),
      isDeceased: person.isDeceased == 1,
      is_Active: true,
      child_Count: 0,
      //location: person.location,
      //nationality: person.nationality,
    );
  }
}
