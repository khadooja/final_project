import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

class CommonDropdownsChidModel {
  List<NationalityModel> nationalities;
  List<CountryModel> countries;
  List<SpecialCase> specialCases;

  CommonDropdownsChidModel({
    required this.nationalities,
    required this.countries,
    required this.specialCases,
  });

  factory CommonDropdownsChidModel.fromJson(Map<String, dynamic> json) {
    print('JSON CommonDropdownsChidModel..............................: $json');
    return CommonDropdownsChidModel(
      nationalities: (json['nationalities'] as List<dynamic>)
          .map((e) => NationalityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      countries: (json['countries'] as List<dynamic>)
          .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialCases: (json['specialCases'] as List<dynamic>)
          .map((e) => SpecialCase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nationalities': nationalities.map((item) => item.toJson()).toList(),
      'countries': countries.map((item) => item.toJson()).toList(),
      'specialCases': specialCases.map((item) => item.toJson()).toList(),
    };
  }
}
