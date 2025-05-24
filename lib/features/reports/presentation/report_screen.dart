import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/features/reports/logic/report_cubit.dart';
import 'package:new_project/features/reports/logic/report_state.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportCubit>(
      create: (_) => di<ReportCubit>()..loadReports(),
      child: const _ReportContent(),
    );
  }
}

class _ReportContent extends StatelessWidget {
  const _ReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          } else if (state is ReportLoaded) {
            final general = state.report.generalStats;
            final centers = state.report.centerStats;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildStatCard(
                          "عدد الأطفال", general.childrenCount, Colors.green),
                      _buildStatCard("الحالات الخاصة",
                          general.childrenWithSpecialCasesCount, Colors.orange),
                      _buildStatCard(
                          "الجرعات", general.allDosesCount, Colors.red),
                      _buildStatCard("المكتملة تطعيماتهم",
                          general.completedChildrenCount, Colors.blue),
                      _buildStatCard(
                          "المتأخرة تطعيماتهم",
                          general.childrenWithDelayedVaccinations,
                          Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("الإحصائيات الخاصة",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("المركز الصحي")),
                        DataColumn(label: Text("الأطفال")),
                        DataColumn(label: Text("الحالات الخاصة")),
                        DataColumn(label: Text("المكتملة تطعيماتهم")),
                        DataColumn(label: Text("المتأخرة تطعيماتهم")),
                        DataColumn(label: Text("الجرعات")),
                      ],
                      rows: centers
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e.centerName)),
                                DataCell(Text('${e.childrenCount}')),
                                DataCell(
                                    Text('${e.childrenWithSpecialCasesCount}')),
                                DataCell(Text('${e.completedChildrenCount}')),
                                DataCell(Text(
                                    '${e.childrenWithDelayedVaccinations}')),
                                DataCell(Text('${e.allDosesCount}')),
                              ]))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox(); // في حالة state أخرى غير متوقعة
        },
      ),
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 160,
        height: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              "$value",
              style: TextStyle(
                  color: color, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
