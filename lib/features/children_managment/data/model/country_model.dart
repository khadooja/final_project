class CountryModel {
  final String name;

  CountryModel({
    required this.name,
  });

 factory CountryModel.fromJson(Map<String, dynamic> json) {
  print('CountryModel.fromJson: $json');
  if (!json.containsKey('name')) {
    throw Exception('Missing required key: name');
  }
  return CountryModel(name: json['name']);
}

  get id => null;

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}
