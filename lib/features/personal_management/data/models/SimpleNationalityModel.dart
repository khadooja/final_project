class SimpleNationalityModel {
  final int id;
  final String country_name;

  SimpleNationalityModel({
    required this.id,
    required this.country_name,
  });

  factory SimpleNationalityModel.fromJson(Map<String, dynamic> json) {
  print('JSON SimpleNationalityModel..............................: $json');
  return SimpleNationalityModel(
    id: json['id'],
    country_name: json['country_name'],
  );
}
  Map<String, dynamic> toJson() => {
        'id': id,
        'country_name': country_name,
      };
}
