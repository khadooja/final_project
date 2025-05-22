// features/children_managment/data/model/child_list_response_model.dart
import 'package:json_annotation/json_annotation.dart';
// Adjust the import path according to your project structure
import '../../../../features/children_managment/data/model/displayed_child_model.dart';

part 'child_list_response_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class ChildListResponseModel {
  final int count;
  final List<DisplayedChildModel> data;

  ChildListResponseModel({required this.count, required this.data});

  factory ChildListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChildListResponseModelFromJson(json);
}
