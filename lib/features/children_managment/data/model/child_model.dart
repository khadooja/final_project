class ChildModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String gender;
  final int hasSpecialCase;
  final String birthCertificateNumber;
  final String birthCertificateType;
  final int nationalitiesId;
  final int fathersId;
  final int mothersId;
  final int countriesId;
  final int foreingBirthCountryId;
  final String? caseName;
  final String? description;
  final String? startDate;

  ChildModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.hasSpecialCase,
    required this.birthCertificateNumber,
    required this.birthCertificateType,
    required this.nationalitiesId,
    required this.fathersId,
    required this.mothersId,
    required this.countriesId,
    required this.foreingBirthCountryId,
    this.caseName,
    this.description,
    this.startDate,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    print("ChildModel.fromJson: $json");
    return ChildModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      hasSpecialCase: json['has_specail_case'],
      birthCertificateNumber: json['birth_certificate_number'],
      birthCertificateType: json['birth_certificate_type'],
      nationalitiesId: json['nationalities_id'],
      fathersId: json['fathers_id'],
      mothersId: json['mothers_id'],
      countriesId: json['countries_id'],
      foreingBirthCountryId: json['foreing_birth_country_id'],
      caseName: json['case_name'],
      description: json['description'],
      startDate: json['start_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "birth_date": birthDate,
      "gender": gender,
      "has_specail_case": hasSpecialCase,
      "birth_certificate_number": birthCertificateNumber,
      "birth_certificate_type": birthCertificateType,
      "nationalities_id": nationalitiesId,
      "fathers_id": fathersId,
      "mothers_id": mothersId,
      "countries_id": countriesId,
      "foreing_birth_country_id": foreingBirthCountryId,
      "case_name": caseName,
      "description": description,
      "start_date": startDate,
    };
  }
}
