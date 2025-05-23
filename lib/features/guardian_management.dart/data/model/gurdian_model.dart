import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';

//part 'gurdian_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GurdianModel extends PersonModel {
  final String? notes;
  @JsonKey(name: 'child_count')
  final int? childCount;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'isActive')
  final bool? isActive;

  GurdianModel({
    required super.id,
    required super.first_name,
    required super.last_name,
    required super.gender,
    required super.email,
    required super.phone_number,
    required super.identity_card_number,
    required super.nationalities_id,
    required super.location_id,

    this.notes,
    this.childCount,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  }) :super(
          isDeceased: false,
        );

  factory GurdianModel.fromJson(Map<String, dynamic> json) {
    return GurdianModel(
      id: json['id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      phone_number: json['phone_number'] as String,
      identity_card_number: json['identity_card_number'] as String,
      nationalities_id: json['nationalities_id'] as int,
      location_id: json['location_id'] as int,
      notes: json['notes'] as String,
      childCount: json['child_count'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isActive: json['isActive'] as bool,
      //isDeceased: json['isDeceased'] as bool,
    );
  }
     

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'email': email,
      'phone_number': phone_number, 
      'identity_card_number': identity_card_number,
      'nationalities_id': nationalities_id,
      'location_id': location_id,
      'notes': notes,
      'child_count': childCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'isActive': isActive,
      'isDeceased': isDeceased,
    };
  }

  
}
