import 'package:new_project/Core/networking/api_services.dart';

import '../model/report_response_model.dart';

class ReportRepository {
  final ApiServiceManual api;

  ReportRepository({required this.api});

  Future<ReportResponseModel> getReportData({int? centerId}) async {
    final json = await api.fetchReportData(centerId: centerId);
    return ReportResponseModel.fromJson(json);
  }
}
