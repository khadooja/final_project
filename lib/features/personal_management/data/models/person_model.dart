import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

part 'person_model.g.dart';

@JsonSerializable(
  explicitToJson: true, // ضروري للتعامل مع الوراثة
  anyMap: true, // ليدعم Map بأي نوع مفتاح
)
class PersonModel {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String identityCardNumber;
  final int nationalitiesId;
  final int locationId;
  final DateTime birthDate;

  @JsonKey(includeToJson: false)
  final PersonType? type;

  PersonModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.identityCardNumber,
    required this.nationalitiesId,
    required this.locationId,
    required this.birthDate,
    this.type,
  });
  String get name => "$firstName $lastName";

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonModelToJson(this);
}
