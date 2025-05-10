import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

class NationalitiesAndCitiesModel {
  final List<NationalityModel> nationalities;
  final List<CityModel> cities;

  NationalitiesAndCitiesModel({
    required this.nationalities,
    required this.cities,
  });

  // التحويل من JSON إلى Model (يدوي)
  factory NationalitiesAndCitiesModel.fromJson(Map<String, dynamic> json) {
    return NationalitiesAndCitiesModel(
      nationalities: (json['nationalities'] as List)
          .map((item) => NationalityModel.fromJson(item))
          .toList(),
      cities: (json['cities'] as List)
          .map((item) => CityModel.fromJson(item))
          .toList(),
    );
  }

  // التحويل من Model إلى JSON (يدوي)
  Map<String, dynamic> toJson() {
    return {
      'nationalities': nationalities.map((item) => item.toJson()).toList(),
      'cities': cities.map((item) => item.toJson()).toList(),
    };
  }
}
