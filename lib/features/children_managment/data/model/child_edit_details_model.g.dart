// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_edit_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialCaseDetailModel _$SpecialCaseDetailModelFromJson(
        Map<String, dynamic> json) =>
    SpecialCaseDetailModel(
      caseName: json['case_name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SpecialCaseDetailModelToJson(
        SpecialCaseDetailModel instance) =>
    <String, dynamic>{
      'case_name': instance.caseName,
      'description': instance.description,
    };

NationalityItemModel _$NationalityItemModelFromJson(
        Map<String, dynamic> json) =>
    NationalityItemModel(
      nationalityId: (json['nationality_id'] as num).toInt(),
      nationalityName: json['nationality_name'] as String,
    );

Map<String, dynamic> _$NationalityItemModelToJson(
        NationalityItemModel instance) =>
    <String, dynamic>{
      'nationality_id': instance.nationalityId,
      'nationality_name': instance.nationalityName,
    };

CountryItemModel _$CountryItemModelFromJson(Map<String, dynamic> json) =>
    CountryItemModel(
      countryId: (json['country_id'] as num).toInt(),
      countryName: json['country_name'] as String,
    );

Map<String, dynamic> _$CountryItemModelToJson(CountryItemModel instance) =>
    <String, dynamic>{
      'country_id': instance.countryId,
      'country_name': instance.countryName,
    };

ChildEditDetailsModel _$ChildEditDetailsModelFromJson(
        Map<String, dynamic> json) =>
    ChildEditDetailsModel(
      childId: (json['child_id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthDate: json['birth_date'] as String,
      vaccineCardNumber: json['vaccine_card_number'] as String?,
      gender: json['gender'] as String,
      birthCertificateType: json['birth_certificate_type'] as String,
      birthCertificateNumber: json['birth_certificate_number'] as String?,
      nationalityName: json['nationality_name'] as String,
      countryName: json['country_name'] as String?,
      hasSpecialCase:
          ChildEditDetailsModel._boolFromInt(json['has_special_case']),
      specialCaseDetails: (json['special_case_details'] as List<dynamic>?)
          ?.map(
              (e) => SpecialCaseDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialCaseStartDate: (json['special_case_start_date'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      fatherName: json['father_name'] as String?,
      motherName: json['mother_name'] as String?,
      nationality: (json['nationality'] as List<dynamic>)
          .map((e) => NationalityItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      country: (json['country'] as List<dynamic>)
          .map((e) => CountryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nationalityOptions: (json['nationality'] as List<dynamic>? ?? [])
          .map(
              (e) => NationalityOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      countryOptions: (json['country'] as List<dynamic>? ?? [])
          .map((e) => CountryOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialCaseTypeOptions: (json['special_cases'] as List<dynamic>? ?? [])
          .map(
              (e) => SpecialCaseOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChildEditDetailsModelToJson(
        ChildEditDetailsModel instance) =>
    <String, dynamic>{
      'child_id': instance.childId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'birth_date': instance.birthDate,
      'vaccine_card_number': instance.vaccineCardNumber,
      'gender': instance.gender,
      'birth_certificate_type': instance.birthCertificateType,
      'birth_certificate_number': instance.birthCertificateNumber,
      'nationality_name': instance.nationalityName,
      'country_name': instance.countryName,
      'has_special_case':
          ChildEditDetailsModel._boolToInt(instance.hasSpecialCase),
      'special_case_details':
          instance.specialCaseDetails?.map((e) => e.toJson()).toList(),
      'special_case_start_date': instance.specialCaseStartDate,
      'father_name': instance.fatherName,
      'mother_name': instance.motherName,
      'nationality': instance.nationality.map((e) => e.toJson()).toList(),
      'country': instance.country.map((e) => e.toJson()).toList(),
    };
