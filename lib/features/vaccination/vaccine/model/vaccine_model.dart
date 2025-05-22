import 'package:new_project/features/vaccination/dose/model/dose_model.dart';
import 'package:new_project/features/vaccination/stage/model/StageModel.dart';

class VaccineModel {
  final int id;
  final String name;
  final String? description;
  final int doseCount;
  final String category;
  String status;
  final List<StageModel> stages;
  final List<DoseModel> doses;

  VaccineModel({
    required this.id,
    required this.name,
    this.description,
    required this.doseCount,
    required this.category,
    required this.status,
    required this.stages,
    required this.doses,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      id: json['id'],
      name: json['vaccine_name'],
      description: json['description'],
      doseCount: json['dose_count'],
      category: json['category'],
      status: json['status'],
      doses: (json['doses'] as List?)
              ?.map((e) => DoseModel.fromJson(e))
              .toList() ??
          [],
      stages: (json['stages'] as List?)
              ?.map((e) => StageModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'vaccine_name': name,
      'description': description,
      'category': category,
      'dose_count': doseCount.toString(),
      'stages': stages.map((s) => s.id).toList(),
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
}
