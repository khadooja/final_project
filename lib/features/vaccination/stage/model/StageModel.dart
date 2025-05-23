class StageModel {
  final int id;
  final String stageName;
  final String? description;
  final int stageStartAgeMonths;
  final int stageEndAgeMonths;

  StageModel({
    required this.id,
    required this.stageName,
    this.description,
    required this.stageStartAgeMonths,
    required this.stageEndAgeMonths,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'],
      stageName: json['stage_name'],
      description: json['description'],
      stageStartAgeMonths: json['stage_start_age_months'],
      stageEndAgeMonths: json['stage_end_age_months'],
    );
  }
}
