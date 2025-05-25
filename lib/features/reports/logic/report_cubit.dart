import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/report_repository.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository repository;

  ReportCubit({required this.repository}) : super(ReportInitial());

  Future<void> loadReports({int? centerId}) async {
    emit(ReportLoading());
    try {
      final report = await repository.getReportData(centerId: centerId);
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
