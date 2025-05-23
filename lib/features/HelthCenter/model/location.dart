class Location {
  final int id;
  final String name;

  Location({required this.id, required this.name});

  // تحويل كائن Location إلى خريطة JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // تحويل JSON إلى كائن Location
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      name: json['city_name'] ?? json['name'] ?? json['area_name'] ?? 'Unknown',
    );
  }
}
