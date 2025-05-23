// lib/features/vaccination/stage/data/repos/stage_repo.dart
import 'package:dio/dio.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/config/api_config.dart';
import 'package:new_project/features/vaccination/stage/model/StageModel.dart';

class StageRepository {
  final ApiServiceManual api;

  StageRepository({required this.api});

  Future<StageModel> createStage(Map<String, dynamic> data) async {
    final response = await api.post('${ApiConfig.baseUrl}stages/store', data);
    final responseData = response['data'];

    return StageModel(
      id: responseData['id'],
      stageName: responseData['stage_name'],
      description: responseData['description'],
      stageStartAgeMonths: responseData['stage_start_age_months'],
      stageEndAgeMonths: responseData['stage_end_age_months'],
    );
  }
}
