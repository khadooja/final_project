class HealthCenter {
  final int id;
  final String name;
  final String phoneNumber;
  final int locationId;

  HealthCenter({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.locationId,
  });

  factory HealthCenter.fromJson(Map<String, dynamic> json) {
    return HealthCenter(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      locationId: json['location_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'location_id': locationId,
    };
  }
}
