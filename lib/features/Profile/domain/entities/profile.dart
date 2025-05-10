class UserProfile {
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

  UserProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.position,
    required this.workplace,
    required this.role,
    required this.profileImageUrl,
    required this.employment_date,
    required this.isactive,
    required this.location,
    required this.nationality,
  });
}
