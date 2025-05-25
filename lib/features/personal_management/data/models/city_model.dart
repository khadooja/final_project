class CityModel {
  final String city_name;

  CityModel({
    required this.city_name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    print('JSON CityModel..............................: $json');
    return CityModel(
      city_name: json['city_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'city_name': city_name,
      };
}
