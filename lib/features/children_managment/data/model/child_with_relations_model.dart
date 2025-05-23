import 'package:json_annotation/json_annotation.dart';
import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

part 'child_with_relations_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildWithRelationsModel {
  final ChildModel child;
  final List<SpecialCase>? specialCases;
  final CountryModel? countryModel;
  final NationalityModel nationality;

  ChildWithRelationsModel({
    required this.child,
    this.specialCases,
    this.countryModel,
    required this.nationality,
  });

  factory ChildWithRelationsModel.fromJson(Map<String, dynamic> json) =>
      _$ChildWithRelationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildWithRelationsModelToJson(this);

  @override
  String toString() {
    return '''
ChildWithRelations:
  Child: ${child.toString()}
  Special Cases: ${specialCases?.length ?? 0}
  Birth City: ${countryModel?.name ?? 'N/A'}
  Nationality: ${nationality.nationality_name}
''';
  }
}
