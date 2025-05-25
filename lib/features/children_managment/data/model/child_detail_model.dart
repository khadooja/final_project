// Create a new file, e.g., features/children_managment/data/model/child_detail_model.dart

class NationalityOptionModel {
  final int nationalityId;
  final String nationalityName;
  NationalityOptionModel(
      {required this.nationalityId, required this.nationalityName});
  factory NationalityOptionModel.fromJson(Map<String, dynamic> json) =>
      NationalityOptionModel(
          nationalityId: json['nationality_id'],
          nationalityName: json['nationality_name']);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NationalityOptionModel &&
          runtimeType == other.runtimeType &&
          nationalityId == other.nationalityId;
  @override
  int get hashCode => nationalityId.hashCode;
}

class CountryOptionModel {
  final int countryId;
  final String countryName;

  CountryOptionModel({required this.countryId, required this.countryName});

  factory CountryOptionModel.fromJson(Map<String, dynamic> json) {
    return CountryOptionModel(
      countryId: json['country_id'],
      countryName: json['country_name'],
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryOptionModel &&
          runtimeType == other.runtimeType &&
          countryId == other.countryId;

  @override
  int get hashCode => countryId.hashCode;
}

class SpecialCaseOptionModel {
  final int specialCaseId;
  final String specialCaseName;
  final String? specialCaseDescription;

  SpecialCaseOptionModel({
    required this.specialCaseId,
    required this.specialCaseName,
    this.specialCaseDescription,
  });

  factory SpecialCaseOptionModel.fromJson(Map<String, dynamic> json) {
    return SpecialCaseOptionModel(
      specialCaseId: json['specialCase_id'],
      specialCaseName: json['specialCase_name'],
      specialCaseDescription: json['specialCase_description'],
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialCaseOptionModel &&
          runtimeType == other.runtimeType &&
          specialCaseId == other.specialCaseId;

  @override
  int get hashCode => specialCaseId.hashCode;
}

class SpecialCaseDetailModel {
  final String caseName;
  final String? description;

  SpecialCaseDetailModel({required this.caseName, this.description});

  factory SpecialCaseDetailModel.fromJson(Map<String, dynamic> json) {
    return SpecialCaseDetailModel(
      caseName: json['case_name'],
      description: json['description'],
    );
  }
}

class ChildDetailModel {
  final int childId;
  final String firstName;
  final String lastName;
  final String? birthDate; // "YYYY-MM-DD"
  final String vaccineCardNumber;
  final String gender;
  final String birthCertificateType;
  final String birthCertificateNumber;
  final String currentNationalityName; // The child's actual nationality name
  final String
      currentCountryName; // The child's actual country of birth cert issuance
  final int hasSpecialCase; // 0 or 1 from API
  final List<SpecialCaseDetailModel>
      currentSpecialCaseDetails; // Child's current special cases
  final List<String>
      currentSpecialCaseStartDates; // Child's current special case start dates
  final String fatherName;
  final String motherName;

  // Options for dropdowns
  final List<NationalityOptionModel> nationalityOptions;
  final List<CountryOptionModel> countryOptions;
  final List<SpecialCaseOptionModel> specialCaseTypeOptions;

  ChildDetailModel({
    required this.childId,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    required this.vaccineCardNumber,
    required this.gender,
    required this.birthCertificateType,
    required this.birthCertificateNumber,
    required this.currentNationalityName,
    required this.currentCountryName,
    required this.hasSpecialCase,
    required this.currentSpecialCaseDetails,
    required this.currentSpecialCaseStartDates,
    required this.fatherName,
    required this.motherName,
    required this.nationalityOptions,
    required this.countryOptions,
    required this.specialCaseTypeOptions,
  });

  factory ChildDetailModel.fromJson(Map<String, dynamic> json) {
    return ChildDetailModel(
      childId: json['child_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthDate: json['birth_date'] as String?,
      vaccineCardNumber: json['vaccine_card_number'] as String,
      gender: json['gender'] as String,
      birthCertificateType: json['birth_certificate_type'] as String,
      birthCertificateNumber: json['birth_certificate_number'] as String,
      currentNationalityName: json['nationality_name'] as String, // from root
      currentCountryName: json['country_name'] as String, // from root
      hasSpecialCase: json['has_special_case'] as int, // from root
      currentSpecialCaseDetails:
          (json['special_case_details'] as List<dynamic>? ?? [])
              .map((e) =>
                  SpecialCaseDetailModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      currentSpecialCaseStartDates:
          (json['special_case_start_date'] as List<dynamic>? ?? [])
              .map((e) => e as String)
              .toList(),
      fatherName: json['father_name'] as String,
      motherName: json['mother_name'] as String,
      nationalityOptions: (json['nationality'] as List<dynamic>? ??
              []) // from 'nationality' array
          .map(
              (e) => NationalityOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      countryOptions: (json['country'] as List<dynamic>? ??
              []) // from 'country' array
          .map((e) => CountryOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialCaseTypeOptions: (json['special_cases'] as List<dynamic>? ??
              []) // from 'special_cases' array
          .map(
              (e) => SpecialCaseOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
