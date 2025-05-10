import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

part 'CommonDropdownsChidModel.freezed.dart';
part 'CommonDropdownsChidModel.g.dart';

@freezed
class CommonDropdownsChidModel with _$CommonDropdownsChidModel {
  const factory CommonDropdownsChidModel({
    required List<NationalityModel> nationalities,
    required List<CountryModel> countries,
    required List<SpecialCase> specialCases,
  }) = _CommonDropdownsChidModel;

  factory CommonDropdownsChidModel.fromJson(Map<String, dynamic> json) =>
      _$CommonDropdownsChidModelFromJson(json);
}
