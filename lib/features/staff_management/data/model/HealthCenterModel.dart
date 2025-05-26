class HealthCenterModel {
  final int id;
  final String name;

  HealthCenterModel({required this.id, required this.name});

  factory HealthCenterModel.fromJson(Map<String, dynamic> json) {
    return HealthCenterModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
