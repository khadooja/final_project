class AreaModel {
  final int id;
  final String area_name;
  final String? city_name;

  AreaModel({
    required this.id,
    required this.area_name,
    this.city_name,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    print('🔧 تحويل JSON إلى AreaModel: $json');
    return AreaModel(
      id: json['id'] as int,
      area_name: json['area_name'] as String,
      city_name: json['city_name'] as String?,
    );
  }

  @override
  String toString() => 'AreaModel(id: $id, area_name: $area_name)';
}