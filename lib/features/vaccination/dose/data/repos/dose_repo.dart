import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/config/api_config.dart';
import 'package:new_project/features/vaccination/dose/model/dose_model.dart';

class DoseRepository {
  final ApiServiceManual api;

  DoseRepository({required this.api});

  Future<DoseModel> createDose(Map<String, dynamic> data) async {
    final response = await api.post('${ApiConfig.baseUrl}dose/store', data);

    final responseData = response['data'];

    return DoseModel(
      doseNumber: responseData['dose_number'],
      ageYears: responseData['age_years'],
      ageMonths: responseData['age_months'],
      ageDays: responseData['age_days'],
      delayDays: responseData['delay_days'],
    );
  }
}
