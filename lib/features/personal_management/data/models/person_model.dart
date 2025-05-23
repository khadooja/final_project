import 'package:json_annotation/json_annotation.dart';
import 'location_model.dart';
import 'nationality_model.dart';

part 'person_model.g.dart';

@JsonSerializable()
class PersonModel {
  final int id;
  final String first_name;
  final String last_name;
  final String gender;
  final String? email;
  final String? phone_number;
  final String identity_card_number;
  final bool isDeceased;
  final int nationalities_id;
  final int? location_id;
   final DateTime? birthDate;
  
  @JsonKey(name: 'location')
  final Location? location;
  
  @JsonKey(name: 'nationality')
  final NationalityModel? nationality;

  PersonModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.gender,
    this.email,
    this.phone_number,
    required this.identity_card_number,
    required this.isDeceased,
    required this.nationalities_id,
    this.location_id,
    this.location,
    this.nationality,
    this.birthDate,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) => 
      _$PersonModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonModelToJson(this);
}