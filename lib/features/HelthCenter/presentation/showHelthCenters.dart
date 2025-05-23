import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/HelthCenter/logic/cubit/health_center_cubit.dart';
import 'package:new_project/features/HelthCenter/model/HealthCenterDisplay.dart';
import 'package:new_project/features/HelthCenter/presentation/Add_helth_center_screen.dart';
import 'package:new_project/features/HelthCenter/presentation/HealthCenterForm.dart';
import 'package:new_project/features/HelthCenter/presentation/editHelthCenter.dart';
import '../../../core/commn_widgets/top_bar.dart';
import '../../../core/commn_widgets/custom_button.dart';
import '../../../core/di/get_it.dart';

class HealthCentersScreen extends StatelessWidget {
  const HealthCentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<HealthCenterCubit>()..loadHealthCenters(),
      child: const _HealthCentersBody(),
    );
  }
}

class _HealthCentersBody extends StatelessWidget {
  const _HealthCentersBody();

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
                child: TopBar(title: "قائمة المستوصفات"),
              ),
              Expanded(
                child: BlocBuilder<HealthCenterCubit, HealthCenterState>(
                  builder: (context, state) {
                    if (state is HealthCenterLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HealthCenterError) {
                      return Center(child: Text(state.message));
                    } else if (state is HealthCenterLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: 'إضافة مستوصف جديد',
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddHealthCenterScreen()));
                                      if (result == true) {
                                        context
                                            .read<HealthCenterCubit>()
                                            .loadHealthCenters();
                                      }
                                    },
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('عدد المستوصفات: ${state.count}',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columnSpacing: 20,
                                    headingRowColor: MaterialStateProperty.all(
                                        Colors.grey.shade100),
                                    columns: const [
                                      DataColumn(label: Text('الاسم')),
                                      DataColumn(label: Text('المدير')),
                                      DataColumn(label: Text('الموقع')),
                                      DataColumn(label: Text('الأطفال')),
                                      DataColumn(label: Text('الموظفين')),
                                      DataColumn(label: Text('إجراءات')),
                                    ],
                                    rows: state.centers.map((c) {
                                      return DataRow(cells: [
                                        DataCell(Text(c.name)),
                                        DataCell(Text(c.managerName)),
                                        DataCell(Text(c.locationName)),
                                        DataCell(Text('${c.childrenCount}')),
                                        DataCell(Text('${c.staffCount}')),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () async {
                                                // حول HealthCenterDisplay إلى HealthCenter
                                                final healthCenterModel =
                                                    c.toHealthCenter();

                                                final updated =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        BlocProvider.value(
                                                      value: context.read<
                                                          HealthCenterCubit>(),
                                                      child:
                                                          EditHealthCenterScreen(
                                                        healthCenter:
                                                            healthCenterModel,
                                                      ),
                                                    ),
                                                  ),
                                                );

                                                if (updated == true) {
                                                  context
                                                      .read<HealthCenterCubit>()
                                                      .loadHealthCenters();
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                c.status == 'active'
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: c.status == 'active'
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<HealthCenterCubit>()
                                                    .toggleStatus(c.id);
                                              },
                                            ),
                                          ],
                                        )),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text('لا توجد بيانات');
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
