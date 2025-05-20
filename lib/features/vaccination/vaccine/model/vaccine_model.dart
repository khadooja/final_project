// lib/features/vaccination/vaccine/model/vaccine_model.dart
import '../../dose/model/dose_model.dart';

class VaccineModel {
  final String name;
  final String description;
  final String category;
  final int doseCount;
  final List<int> stages;
  final List<DoseModel> doses;

  VaccineModel({
    required this.name,
    required this.description,
    required this.category,
    required this.doseCount,
    required this.stages,
    required this.doses,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'vaccine_name': name,
      'description': description,
      'category': category,
      'dose_count': doseCount,
      'stages': stages,
    };

    for (int i = 0; i < doses.length; i++) {
      final dose = doses[i];
      int index = i + 1;
      data['dose_${index}_number'] = dose.doseNumber;
      data['dose_${index}_age_years'] = dose.ageYears;
      data['dose_${index}_age_months'] = dose.ageMonths;
      data['dose_${index}_age_days'] = dose.ageDays;
      data['dose_${index}_delay_days'] = dose.delayDays;
    }

    return data;
  }

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    // في حال احتجت لاحقًا لعرض قائمة التطعيمات
    return VaccineModel(
      name: json['vaccine_name'],
      description: json['description'],
      category: json['category'],
      doseCount: json['dose_count'],
      stages: List<int>.from(json['stages']),
      doses: [],
    );
  }
}
