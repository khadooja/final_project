// features/children_managment/data/model/child_edit_details_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/children_managment/data/model/child_detail_model.dart';

part 'child_edit_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SpecialCaseDetailModel {
  @JsonKey(name: 'case_name')
  final String caseName;
  final String? description; // Assuming description can be null or empty

  SpecialCaseDetailModel({required this.caseName, this.description});

  factory SpecialCaseDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialCaseDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialCaseDetailModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NationalityItemModel {
  @JsonKey(name: 'nationality_id')
  final int nationalityId;
  @JsonKey(name: 'nationality_name')
  final String nationalityName;

  NationalityItemModel(
      {required this.nationalityId, required this.nationalityName});

  factory NationalityItemModel.fromJson(Map<String, dynamic> json) =>
      _$NationalityItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$NationalityItemModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CountryItemModel {
  @JsonKey(name: 'country_id')
  final int countryId;
  @JsonKey(name: 'country_name')
  final String countryName;

  CountryItemModel({required this.countryId, required this.countryName});

  factory CountryItemModel.fromJson(Map<String, dynamic> json) =>
      _$CountryItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CountryItemModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChildEditDetailsModel {
  @JsonKey(name: 'child_id')
  final int childId;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'birth_date')
  final String birthDate; // Expecting YYYY-MM-DD string
  @JsonKey(name: 'vaccine_card_number')
  final String? vaccineCardNumber;
  final String gender;
  @JsonKey(name: 'birth_certificate_type')
  final String birthCertificateType;
  @JsonKey(name: 'birth_certificate_number')
  final String? birthCertificateNumber;
  @JsonKey(name: 'nationality_name')
  final String nationalityName; // This seems to be the selected one
  @JsonKey(name: 'country_name')
  final String?
      countryName; // This seems to be the selected one for external birth cert
  @JsonKey(name: 'has_special_case', fromJson: _boolFromInt, toJson: _boolToInt)
  final bool hasSpecialCase;
  @JsonKey(name: 'special_case_details')
  final List<SpecialCaseDetailModel>? specialCaseDetails;
  @JsonKey(name: 'special_case_start_date')
  final List<String>? specialCaseStartDate; // List of YYYY-MM-DD strings
  @JsonKey(name: 'father_name')
  final String? fatherName;
  @JsonKey(name: 'mother_name')
  final String? motherName;

  // Lists for dropdown population
  final List<NationalityItemModel> nationality;
  final List<CountryItemModel> country;
  final List<NationalityOptionModel> nationalityOptions;
  final List<CountryOptionModel> countryOptions;
  final List<SpecialCaseOptionModel> specialCaseTypeOptions;

  ChildEditDetailsModel({
    required this.childId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.vaccineCardNumber,
    required this.gender,
    required this.birthCertificateType,
    this.birthCertificateNumber,
    required this.nationalityName,
    this.countryName,
    required this.hasSpecialCase,
    this.specialCaseDetails,
    this.specialCaseStartDate,
    this.fatherName,
    this.motherName,
    required this.nationality,
    required this.country,
    required this.nationalityOptions,
    required this.countryOptions,
    required this.specialCaseTypeOptions,
  });

  factory ChildEditDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ChildEditDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChildEditDetailsModelToJson(this);

  // Helper for has_special_case (1/0 to bool)
  static bool _boolFromInt(dynamic value) => value == 1 || value == true;
  static int _boolToInt(bool value) => value ? 1 : 0;
}
