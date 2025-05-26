import 'package:new_project/features/guardian_management.dart/data/model/relation_model.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

class ChildGuardianModel {
  final int id;
  final int nationalitiesId;
  final int locationId;
  final int relationshipTypesId;

  final String identityCardNumber;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String endDate;
  final bool isDeceased;
  final bool isActive;
  final int childCount;

  // بيانات الربط للعرض فقط (اختياري)
  final RelationModel? relationshipType;
  final NationalityModel? nationality;
  final AreaModel? location;

  ChildGuardianModel({
    required this.id,
    required this.nationalitiesId,
    required this.locationId,
    required this.relationshipTypesId,
    required this.identityCardNumber,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.endDate,
    required this.isDeceased,
    required this.isActive,
    required this.childCount,
    this.relationshipType,
    this.nationality,
    this.location,
  });

  factory ChildGuardianModel.fromJson(Map<String, dynamic> json) {
    return ChildGuardianModel(
      id: json['id'],
      nationalitiesId: json['nationalities_id'],
      locationId: json['location_id'],
      relationshipTypesId: json['relationship_types_id'],
      identityCardNumber: json['identity_card_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      endDate: json['end_date'],
      isDeceased: json['isDeceased'] == 1,
      isActive: json['is_Active'] == 1,
      childCount: json['child_count'],

      // للعرض فقط (إذا جا من API)
      relationshipType: json['relationship_type'] != null
          ? RelationModel.fromJson(json['relationship_type'])
          : null,
      nationality: json['nationality'] != null
          ? NationalityModel.fromJson(json['nationality'])
          : null,
      location: json['location'] != null
          ? AreaModel.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nationalities_id": nationalitiesId,
      "location_id": locationId,
      "relationship_types_id": relationshipTypesId,
      "identity_card_number": identityCardNumber,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "email": email,
      "phone_number": phoneNumber,
      "end_date": endDate,
      "isDeceased": isDeceased ? 1 : 0,
      "is_Active": isActive ? 1 : 0,
      "child_count": childCount,
      "childern_id": id,
      // معلومات العرض ما تدخل في toJson
    };
  }
}
