// features/children_managment/presentation/models/displayed_child_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'displayed_child_model.g.dart';

@JsonSerializable()
class DisplayedChildModel {
  final int childId;
  @JsonKey(name: 'vaccine_card_number', defaultValue: 'N/A')
  final String vaccineCardNumber;
  @JsonKey(name: 'first_name', defaultValue: 'N/A')
  final String firstName;
  @JsonKey(name: 'last_name', defaultValue: 'N/A')
  final String lastName;
  @JsonKey(defaultValue: 'N/A')
  final String gender;
  @JsonKey(name: 'mother_name', defaultValue: 'N/A')
  final String motherName;
  @JsonKey(name: 'mother_email', defaultValue: 'N/A')
  final String motherEmail;
  @JsonKey(name: 'father_name', defaultValue: 'N/A')
  final String fatherName;
  @JsonKey(name: 'father_email', defaultValue: 'N/A')
  final String fatherEmail;
  @JsonKey(
      name: 'has_cpecail_case',
      defaultValue: 'N/A') // Note: typo "cpecail" from your JSON
  final String hasSpecialCase;
  @JsonKey(name: 'nationality_name', defaultValue: 'N/A')
  final String nationalityName;
  @JsonKey(name: 'birth_certificate_number', defaultValue: 'N/A')
  final String birthCertificateNumber;
  @JsonKey(name: 'birth_certificate_type', defaultValue: 'N/A')
  final String birthCertificateType;
  @JsonKey(name: 'country_name', defaultValue: 'N/A')
  final String countryName;

  DisplayedChildModel({
    required this.childId,
    required this.vaccineCardNumber,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.motherName,
    required this.motherEmail,
    required this.fatherName,
    required this.fatherEmail,
    required this.hasSpecialCase,
    required this.nationalityName,
    required this.birthCertificateNumber,
    required this.birthCertificateType,
    required this.countryName,
  });

  factory DisplayedChildModel.fromJson(Map<String, dynamic> json) =>
      _$DisplayedChildModelFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayedChildModelToJson(this);
}
