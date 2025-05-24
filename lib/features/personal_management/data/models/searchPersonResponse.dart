import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';

class SearchPersonResponse {
  final String? message;
  final PersonData? data;

  SearchPersonResponse({
    this.message,
    this.data,
  });

  factory SearchPersonResponse.fromJson(Map<String, dynamic> json) {
    print("\n\n\n.........................................$json\n\n\n");
    return SearchPersonResponse(
      message: json['message'],
      data: json['data'] != null ? PersonData.fromJson(json['data']) : null,
    );
  }
}

class PersonData {
  final PersonModel? person;
  final FatherModel? father;

  PersonData({
    this.person,
    this.father,
  });

  factory PersonData.fromJson(Map<String, dynamic> json) {
    print("\n\n\n.........................................$json\n\n\n");
    return PersonData(
      person: json['person'] != null ? PersonModel.fromJson(json['person']) : null,
      father: json['father'] != null ? FatherModel.fromJson(json['father']) : null,
    );
  }
}