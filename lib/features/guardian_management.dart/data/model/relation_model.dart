
class RelationModel {
  final int id;
  final String name;

  RelationModel({
    required this.id,
    required this.name,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json){
    print("RelationModel.fromJson: $json");
    return RelationModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
