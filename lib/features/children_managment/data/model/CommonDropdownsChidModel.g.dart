// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommonDropdownsChidModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommonDropdownsChidModelImpl _$$CommonDropdownsChidModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CommonDropdownsChidModelImpl(
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

Map<String, dynamic> _$$CommonDropdownsChidModelImplToJson(
        _$CommonDropdownsChidModelImpl instance) =>
    <String, dynamic>{
      'nationalities': instance.nationalities,
      'countries': instance.countries,
      'specialCases': instance.specialCases,
    };
