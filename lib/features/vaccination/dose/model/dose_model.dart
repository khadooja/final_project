import 'package:new_project/features/vaccination/stage/model/StageModel.dart';

class DoseModel {
  final String doseNumber;
  final int ageYears;
  final int ageMonths;
  final int ageDays;
  final int delayDays;

  DoseModel({
    required this.doseNumber,
    required this.ageYears,
    required this.ageMonths,
    required this.ageDays,
    required this.delayDays,
  });

  factory DoseModel.fromJson(Map<String, dynamic> json) {
    return DoseModel(
      doseNumber: json['dose_number'],
      ageYears: json['age_years'],
      ageMonths: json['age_months'],
      ageDays: json['age_days'],
      delayDays: json['delay_days'],
    );
  }
}
