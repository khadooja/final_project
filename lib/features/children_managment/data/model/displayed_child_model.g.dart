// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'displayed_child_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayedChildModel _$DisplayedChildModelFromJson(Map<String, dynamic> json) =>
    DisplayedChildModel(
      childId: (json['child_id'] as num).toInt(),
      vaccineCardNumber: json['vaccine_card_number'] as String? ?? 'N/A',
      firstName: json['first_name'] as String? ?? 'N/A',
      lastName: json['last_name'] as String? ?? 'N/A',
      gender: json['gender'] as String? ?? 'N/A',
      motherName: json['mother_name'] as String? ?? 'N/A',
      motherEmail: json['mother_email'] as String? ?? 'N/A',
      fatherName: json['father_name'] as String? ?? 'N/A',
      fatherEmail: json['father_email'] as String? ?? 'N/A',
      hasSpecialCase: json['has_cpecail_case'] as String? ?? 'N/A',
      nationalityName: json['nationality_name'] as String? ?? 'N/A',
      birthCertificateNumber:
          json['birth_certificate_number'] as String? ?? 'N/A',
      birthCertificateType: json['birth_certificate_type'] as String? ?? 'N/A',
      countryName: json['country_name'] as String? ?? 'N/A',
    );

Map<String, dynamic> _$DisplayedChildModelToJson(
        DisplayedChildModel instance) =>
    <String, dynamic>{
      'child_id': instance.childId,
      'vaccine_card_number': instance.vaccineCardNumber,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'mother_name': instance.motherName,
      'mother_email': instance.motherEmail,
      'father_name': instance.fatherName,
      'father_email': instance.fatherEmail,
      'has_cpecail_case': instance.hasSpecialCase,
      'nationality_name': instance.nationalityName,
      'birth_certificate_number': instance.birthCertificateNumber,
      'birth_certificate_type': instance.birthCertificateType,
      'country_name': instance.countryName,
    };
