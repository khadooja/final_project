// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_dropdowns_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonDropDownsResponse _$CommonDropDownsResponseFromJson(
        Map<String, dynamic> json) =>
    CommonDropDownsResponse(
      nationalities: (json['nationalities'] as List<dynamic>)
          .map((e) => NationalityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      cities: (json['cities'] as List<dynamic>)
          .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommonDropDownsResponseToJson(
        CommonDropDownsResponse instance) =>
    <String, dynamic>{
      'nationalities': instance.nationalities,
      'cities': instance.cities,
    };
