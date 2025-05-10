class DropdownData {
  final List<Location> locations;
  final List<Nationality> nationalities;
  final List<HealthCenter> healthCenters;
  final List<Position> positions;

  DropdownData({
    List<Location>? locations,
    List<Nationality>? nationalities,
    List<HealthCenter>? healthCenters,
    List<Position>? positions,
  })  : locations = locations ?? [],
        nationalities = nationalities ?? [],
        healthCenters = healthCenters ?? [],
        positions = positions ?? [];

  factory DropdownData.fromJson(Map<String, dynamic> json) {
    try {
      return DropdownData(
        locations: _parseList(json['locations'], Location.fromJson),
        nationalities: _parseList(json['nationalities'], Nationality.fromJson),
        healthCenters: _parseList(json['healthCenters'], HealthCenter.fromJson),
        positions: _parseList(json['positions'], Position.fromJson),
      );
    } catch (e) {
      throw FormatException('Failed to parse DropdownData: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'locations': locations.map((location) => location.toJson()).toList(),
      'nationalities':
          nationalities.map((nationality) => nationality.toJson()).toList(),
      'healthCenters':
          healthCenters.map((healthCenter) => healthCenter.toJson()).toList(),
      'positions': positions.map((position) => position.toJson()).toList(),
    };
  }

  static List<T> _parseList<T>(
      dynamic data, T Function(Map<String, dynamic>) fromJson) {
    if (data == null || data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .whereType<T>()
        .toList();
  }
}

class Location {
  final int id;
  final String cities;
  final String areas;
  final String streets;

  Location({
    required this.id,
    required this.cities,
    required this.areas,
    required this.streets,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int? ?? 0,
      cities: json['cities'] as String? ?? '',
      areas: json['areas'] as String? ?? '',
      streets: json['streets'] as String? ?? '',
    );
  }

  toJson() {
    return {
      'id': id,
      'cities': cities,
      'areas': areas,
      'streets': streets,
    };
  }
}

class Nationality {
  final int id;
  final String countryName;
  final String countryCode;
  final String nationalityName;

  Nationality({
    required this.id,
    required this.countryName,
    required this.countryCode,
    required this.nationalityName,
  });

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      id: json['id'] as int? ?? 0,
      countryName: json['country_name'] as String? ?? '',
      countryCode: json['country_code'] as String? ?? '',
      nationalityName: json['nationality_name'] as String? ?? '',
    );
  }
  toJson() {
    return {
      'id': id,
      'country_name': countryName,
      'country_code': countryCode,
      'nationality_name': nationalityName,
    };
  }
}

class HealthCenter {
  final int id;
  final String name;
  final String locationId;
  final String phoneNumber;

  HealthCenter({
    required this.id,
    required this.name,
    required this.locationId,
    required this.phoneNumber,
  });

  factory HealthCenter.fromJson(Map<String, dynamic> json) {
    return HealthCenter(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      locationId: json['location_id']?.toString() ?? '0',
      phoneNumber: json['phone_number'] as String? ?? '',
    );
  }
  toJson() {
    return {
      'id': id,
      'name': name,
      'location_id': locationId,
      'phone_number': phoneNumber,
    };
  }
}

class Position {
  final int id;
  final String name;

  Position({
    required this.id,
    required this.name,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
  toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
