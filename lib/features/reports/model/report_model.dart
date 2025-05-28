class GeneralReportModel {
  final int childrenCount;
  final int allDosesCount;
  final int completedChildrenCount;
  final int childrenWithSpecialCasesCount;
  final int childrenWithDelayedVaccinations;

  GeneralReportModel({
    required this.childrenCount,
    required this.allDosesCount,
    required this.completedChildrenCount,
    required this.childrenWithSpecialCasesCount,
    required this.childrenWithDelayedVaccinations,
  });

  factory GeneralReportModel.fromJson(Map<String, dynamic> json) {
    return GeneralReportModel(
      childrenCount: json['childrenCount'] ?? 0,
      allDosesCount: json['allDosesCount'] ?? 0,
      completedChildrenCount: json['completedChildrenCount'] ?? 0,
      childrenWithSpecialCasesCount: json['childrenWithSpecialCasesCount'] ?? 0,
      childrenWithDelayedVaccinations:
          json['childrenWithDelayedVaccinations'] ?? 0,
    );
  }
}
