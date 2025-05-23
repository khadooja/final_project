// class HealthCenterDisplay {
//   final int id;
//   final String name;
//   final int childrenCount;
//   final int staffCount;
//   final String managerName;
//   final String locationName;
//   final String status;

//   HealthCenterDisplay({
//     required this.id,
//     required this.name,
//     required this.childrenCount,
//     required this.staffCount,
//     required this.managerName,
//     required this.locationName,
//     required this.status,
//   });

//   factory HealthCenterDisplay.fromJson(Map<String, dynamic> json) {
//     return HealthCenterDisplay(
//       id: json['id'] ?? 0,
//       name: json['اسم_المستوصف'] ?? json['name'] ?? 'غير معروف',
//       childrenCount: json['عدد_الاطفال'] ?? 0,
//       staffCount: json['عدد_الموظفين'] ?? 0,
//       managerName: json['مدير_المستوصف'] ?? 'غير معروف',
//       locationName: json['الموقع'] ?? 'غير معروف',
//       status: json['status'] ?? 'inactive',
//     );
//   }
// }
import 'package:new_project/features/HelthCenter/model/helth_center.dart';

class HealthCenterDisplay {
  final int id;
  final String name;
  final int childrenCount;
  final int staffCount;
  final String managerName;
  final String locationName;
  final String status;
  final String phoneNumber;

  HealthCenterDisplay({
    required this.id,
    required this.name,
    required this.childrenCount,
    required this.staffCount,
    required this.managerName,
    required this.locationName,
    required this.status,
    required this.phoneNumber,
  });

  factory HealthCenterDisplay.fromJson(Map<String, dynamic> json) {
    return HealthCenterDisplay(
      id: json['رقم_المستوصف'] ?? json['id'] ?? 0,
      name: json['اسم_المستوصف'] ?? json['name'] ?? 'غير معروف',
      childrenCount: json['عدد_الاطفال'] ?? 0,
      staffCount: json['عدد_الموظفين'] ?? 0,
      managerName: json['مدير_المستوصف'] ?? 'غير معروف',
      locationName: json['الموقع'] ?? 'غير معروف',
      status: json['حالة_المستوصف'] ?? 'inactive',
      phoneNumber: json['رقم_الهاتف'] ?? 'غير معروف',
    );
  }
}

// إضافة هذا الإكستنشن لتحويل HealthCenterDisplay إلى HealthCenter
extension HealthCenterDisplayExtension on HealthCenterDisplay {
  HealthCenter toHealthCenter() {
    return HealthCenter(
      id: this.id,
      name: this.name,
      phoneNumber: this
          .phoneNumber, // لأن HealthCenter يحتاج phoneNumber، ممكن تعدلي لو عندك
      locationId:
          0, // تحتاجين طريقة لتحويل locationName إلى locationId حسب حالتك
    );
  }
}
