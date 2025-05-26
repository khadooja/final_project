import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(explicitToJson: true)
class SpecialCase {
  final int id;
  final String caseName;
  final String description;

  SpecialCase({
    required this.id,
    required this.caseName,
    required this.description,
  });

  factory SpecialCase.fromJson(Map<String, dynamic> json) {
    print('SpecialCase.fromJson: $json');
    return 
SpecialCase(
      id: json['id'] as int,
      caseName: json['caseName'] as String,
      description: json['description'] as String,
    );
  }
      

  Map<String, dynamic> toJson() {
    print('SpecialCase.toJson: $this');
    return {
      'id': id,
      'caseName': caseName,
      'description': description,
    };
  }
}
