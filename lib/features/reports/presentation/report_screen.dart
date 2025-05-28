import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/features/reports/logic/report_cubit.dart';
import 'package:new_project/features/reports/logic/report_state.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';

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

class _ReportContent extends StatefulWidget {
  const _ReportContent({super.key});

  @override
  _ReportContentState createState() => _ReportContentState();
}

class _ReportContentState extends State<_ReportContent> {
  int? selectedHealthCenter;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TopBar(title: "التقارير"),
              ),
              Expanded(
                child: BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    if (state is ReportLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ReportError) {
                      return Center(child: Text('حدث خطأ: ${state.message}'));
                    } else if (state is ReportLoaded) {
                      final general = state.report.generalStats;
                      final centers = state.report.centerStats;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "الإحصائيات العامة",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),

                            // كروت الإحصائيات داخل SizedBox أو Container بدون Expanded
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildStatCard("عدد الأطفال",
                                    general.childrenCount, Colors.green),
                                _buildStatCard(
                                    "الحالات الخاصة",
                                    general.childrenWithSpecialCasesCount,
                                    Colors.orange),
                                _buildStatCard("الجرعات", general.allDosesCount,
                                    Colors.red),
                                _buildStatCard(
                                    "المكتملة تطعيماتهم",
                                    general.completedChildrenCount,
                                    Colors.blue),
                                _buildStatCard(
                                    "المتأخرة تطعيماتهم",
                                    general.childrenWithDelayedVaccinations,
                                    Colors.amber),
                              ],
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              "الإحصائيات الخاصة",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),

                            DropdownButton<int>(
                              hint: const Text('اختيار المركز الصحي'),
                              value: centers.any(
                                      (c) => c.centerId == selectedHealthCenter)
                                  ? selectedHealthCenter
                                  : null,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedHealthCenter = newValue;
                                });
                                if (newValue != null) {
                                  context
                                      .read<ReportCubit>()
                                      .loadReports(centerId: newValue);
                                }
                              },
                              items:
                                  centers.map<DropdownMenuItem<int>>((center) {
                                return DropdownMenuItem<int>(
                                  value: center.centerId,
                                  child: Text(center.centerName),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),

                            // الجدول داخل Expanded حتى ياخذ المساحة المتبقية ويظهر بشكل صحيح
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width),
                                    child: DataTable(
                                      columnSpacing: 30,
                                      headingRowColor:
                                          MaterialStateProperty.all(
                                              Colors.grey.shade100),
                                      columns: const [
                                        DataColumn(label: Text('اسم المركز')),
                                        DataColumn(label: Text('عدد الأطفال')),
                                        DataColumn(
                                            label: Text('الحالات الخاصة')),
                                        DataColumn(label: Text('المكتملة')),
                                        DataColumn(label: Text('المتأخرة')),
                                      ],
                                      rows: (selectedHealthCenter == null
                                              ? centers
                                              : centers.where((c) =>
                                                  c.centerId ==
                                                  selectedHealthCenter))
                                          .map((e) => DataRow(cells: [
                                                DataCell(SizedBox(
                                                    width: 120,
                                                    child: Text(e.centerName))),
                                                DataCell(SizedBox(
                                                    width: 120,
                                                    child: Text(
                                                        '${e.childrenCount}'))),
                                                DataCell(SizedBox(
                                                    width: 120,
                                                    child: Text(
                                                        '${e.childrenWithSpecialCasesCount}'))),
                                                DataCell(SizedBox(
                                                    width: 120,
                                                    child: Text(
                                                        '${e.completedChildrenCount}'))),
                                                DataCell(SizedBox(
                                                    width: 120,
                                                    child: Text(
                                                        '${e.childrenWithDelayedVaccinations}'))),
                                              ]))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text('تعذر تحميل البيانات.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
