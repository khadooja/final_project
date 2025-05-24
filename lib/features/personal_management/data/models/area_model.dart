
class AreaModel {
  final int id;
  final String area_name;

  // ✅ أضف هذه:
  final String? city_name;

  AreaModel({
    required this.id,
    required this.area_name,
    this.city_name,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    print('JSON AreaModel..............................: $json');
    return AreaModel(
      id: json['id'],
      area_name: json['area_name'],
      city_name: json['city_name'], // <-- يجب أن تكون موجودة في الاستجابة من API
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'area_name': area_name,
    'city_name': city_name, // <-- يجب أن تكون موجودة في الاستجابة من API
  };
}
