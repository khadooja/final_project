import 'package:new_project/Core/networking/api_services.dart';

import '../model/report_response_model.dart';

class ReportRepository {
  final ApiServiceManual api;

  ReportRepository({required this.api});


   // افترض أن لديك هذا الكائن الذي يتعامل مع الـ API


  Future<ReportResponseModel> getReportData({int? centerId}) async {
    // إذا تم توفير centerId، نقوم بتمريره كـ query parameter
    final json = await api.fetchReportData(centerId: centerId);
    return ReportResponseModel.fromJson(json);
  }
}


