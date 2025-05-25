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
      childrenCount: json['childrenCount'],
      allDosesCount: json['allDosesCount'],
      completedChildrenCount: json['completedChildrenCount'],
      childrenWithSpecialCasesCount: json['childrenWithSpecialCasesCount'],
      childrenWithDelayedVaccinations: json['childrenWithDelayedVaccinations'],
    );
  }
}
