import 'package:new_project/features/reports/model/report_response_model.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final ReportResponseModel report;
  ReportLoaded(this.report);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}
