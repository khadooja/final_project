import 'package:new_project/features/Profile/domain/entities/profile.dart';

class UserProfile_model {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String nationality;
  final String location;
  final String position;
  final String workplace;
  final String role;
  final String profileImageUrl;
  final bool isactive;
  final DateTime employment_date;
  UserProfile_model({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.nationality,
    required this.location,
    required this.position,
    required this.workplace,
    required this.role,
    required this.profileImageUrl,
    required this.isactive,
    required this.employment_date,
  });

  factory UserProfile_model.fromJson(Map<String, dynamic> json) {
    return UserProfile_model(
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      position: json['position'],
      workplace: json['workplace'],
      role: json['role'],
      location: json['location'],
      nationality: json['nationality'],
      employment_date: json['employment_date'],
      isactive: json['isactive'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'position': position,
      'workplace': workplace,
      'role': role,
      'location': location,
      'nationality': nationality,
      'employment_date': employment_date,
      'isactive': isactive,
      'profileImageUrl': profileImageUrl,
    };
  }

  UserProfile_model copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? nationality,
    String? location,
    String? position,
    String? workplace,
    String? role,
    String? profileImageUrl,
    bool? isactive,
    DateTime? employment_date,
  }) {
    return UserProfile_model(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      position: position ?? this.position,
      workplace: workplace ?? this.nationality,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isactive: isactive ?? this.isactive,
      employment_date: employment_date ?? this.employment_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'nationality': nationality,
      'location': location,
      'position': position,
      'workplace': workplace,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'isactive': isactive,
      'employment_date': employment_date.millisecondsSinceEpoch,
    };
  }

  factory UserProfile_model.fromMap(Map<String, dynamic> map) {
    return UserProfile_model(
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      gender: map['gender'] as String,
      nationality: map['nationality'] as String,
      location: map['location'] as String,
      position: map['position'] as String,
      workplace: map['workplace'] as String,
      role: map['role'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
      isactive: map['isactive'] as bool,
      employment_date:
          DateTime.fromMillisecondsSinceEpoch(map['employment_date'] as int),
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      gender: gender,
      nationality: nationality,
      location: location,
      position: position,
      workplace: workplace,
      role: role,
      profileImageUrl: profileImageUrl,
      employment_date: employment_date,
      isactive: isactive,
    );
  }

  factory UserProfile_model.fromEntity(UserProfile profile) {
    return UserProfile_model(
      fullName: profile.fullName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      gender: profile.gender,
      nationality: profile.nationality,
      location: profile.location,
      position: profile.position,
      workplace: profile.workplace,
      role: profile.role,
      profileImageUrl: profile.profileImageUrl,
      employment_date: profile.employment_date,
      isactive: profile.isactive,
    );
  }
}
