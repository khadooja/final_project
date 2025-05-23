// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildListResponseModel _$ChildListResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChildListResponseModel(
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => DisplayedChildModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
