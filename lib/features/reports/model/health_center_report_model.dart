class CenterReportModel {
  final int centerId;
  final String centerName;
  final int childrenCount;
  final int allDosesCount;
  final int completedChildrenCount;
  final int childrenWithSpecialCasesCount;
  final int childrenWithDelayedVaccinations;

  CenterReportModel({
    required this.centerId,
    required this.centerName,
    required this.childrenCount,
    required this.allDosesCount,
    required this.completedChildrenCount,
    required this.childrenWithSpecialCasesCount,
    required this.childrenWithDelayedVaccinations,
  });

  factory CenterReportModel.fromJson(Map<String, dynamic> json) {
    return CenterReportModel(
      centerId: json['centerId'] ?? 0,
      centerName: json['centerName'] ?? '',
      childrenCount: json['childrenCount'] ?? 0,
      allDosesCount: json['allDosesCount'] ?? 0,
      completedChildrenCount: json['completedChildrenCount'] ?? 0,
      childrenWithSpecialCasesCount: json['childrenWithSpecialCasesCount'] ?? 0,
      childrenWithDelayedVaccinations: json['childrenWithDelayedVaccinations'] ?? 0,
    );
  }
}