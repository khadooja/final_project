import 'package:json_annotation/json_annotation.dart';
import 'nationality_model.dart';
import 'city_model.dart';

part 'common_dropdowns_response.g.dart';

@JsonSerializable()
class CommonDropDownsResponse {
  final List<NationalityModel> nationalities;
  final List<CityModel> cities;

  CommonDropDownsResponse({
    required this.nationalities,
    required this.cities,
  });

  factory CommonDropDownsResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonDropDownsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommonDropDownsResponseToJson(this);
}
