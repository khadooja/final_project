class Role {
  final String key;
  final String value;

  Role({required this.key, required this.value});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      key: json['key'],
      value: json['value'],
    );
  }
}
