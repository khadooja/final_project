class CenterReportModel {
  final String centerName;
  final int childrenCount;
  final int allDosesCount;
  final int completedChildrenCount;
  final int childrenWithSpecialCasesCount;
  final int childrenWithDelayedVaccinations;

  CenterReportModel({
    required this.centerName,
    required this.childrenCount,
    required this.allDosesCount,
    required this.completedChildrenCount,
    required this.childrenWithSpecialCasesCount,
    required this.childrenWithDelayedVaccinations,
  });

  factory CenterReportModel.fromJson(Map<String, dynamic> json) {
    return CenterReportModel(
      centerName: json['centerName'],
      childrenCount: json['childrenCount'],
      allDosesCount: json['allDosesCount'],
      completedChildrenCount: json['completedChildrenCount'],
      childrenWithSpecialCasesCount: json['childrenWithSpecialCasesCount'],
      childrenWithDelayedVaccinations: json['childrenWithDelayedVaccinations'],
    );
  }
}
