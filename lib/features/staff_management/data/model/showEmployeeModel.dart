class Showemployeemodel {
  final int id;
  final String? first_name;
  final String? last_name;
  final String? gender;
  final String? email;
  final String? healthCenterName;
  final int isActive;

  Showemployeemodel({
    required this.id,
    this.first_name,
    this.last_name,
    this.gender,
    this.email,
    this.healthCenterName,
    required this.isActive,
  });

  factory Showemployeemodel.fromJson(Map<String, dynamic> json) {
    return Showemployeemodel(
      id: json["Employee Id"],
      first_name: json["First Name"],
      last_name: json["Last Name"],
      gender: json["Gender"],
      email: json["Email"],
      healthCenterName: json["Health Center Name"], // مهم
      isActive: json["isActive"],
    );
  }
}
