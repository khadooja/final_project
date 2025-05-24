import 'package:new_project/features/reports/model/health_center_report_model.dart';
import 'package:new_project/features/reports/model/report_model.dart';

class ReportResponseModel {
  final GeneralReportModel generalStats;
  final List<CenterReportModel> centerStats;

  ReportResponseModel({
    required this.generalStats,
    required this.centerStats,
  });

  factory ReportResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportResponseModel(
      generalStats: GeneralReportModel.fromJson(json),
      centerStats: List<CenterReportModel>.from(
        json['healthCentersReports'].map((e) => CenterReportModel.fromJson(e)),
      ),
    );
  }
}
