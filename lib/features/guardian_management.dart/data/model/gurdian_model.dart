import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

part 'gurdian_model.g.dart';

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
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.email,
    required super.phoneNumber,
    required super.identityCardNumber,
    required super.nationalitiesId,
    required super.locationId,
    required super.birthDate,
    this.notes,
    this.childCount,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  }) : super(
          type: PersonType.guardian,
        );

  factory GurdianModel.fromJson(Map<String, dynamic> json) =>
      _$GurdianModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GurdianModelToJson(this);

  factory GurdianModel.empty() {
    return GurdianModel(
      id: 0,
      firstName: '',
      lastName: '',
      gender: '',
      email: '',
      phoneNumber: '',
      identityCardNumber: '',
      nationalitiesId: 0,
      locationId: 0,
      birthDate: DateTime.now(),
    );
  }
}
