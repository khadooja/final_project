class SimpleVaccineModel {
  final int id;
  final String name;

  SimpleVaccineModel({required this.id, required this.name});

  factory SimpleVaccineModel.fromJson(Map<String, dynamic> json) {
    return SimpleVaccineModel(
      id: json['id'],
      name: json['vaccine_name'],
    );
  }
}
