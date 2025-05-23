import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/features/vaccination/dose/presentation/add_dose_screen.dart';
import 'package:new_project/features/vaccination/stage/presentation/AddStageScreen.dart';
import 'package:new_project/features/vaccination/vaccine/logic/vaccine_cubit.dart';
import 'package:new_project/features/vaccination/vaccine/presentation/EditVaccineScreen.dart';
import 'package:new_project/features/vaccination/vaccine/presentation/screens/AddVaccineScreen.dart';

class VaccinesListScreen extends StatelessWidget {
  const VaccinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VaccineCubit>(
      create: (_) => di<VaccineCubit>()..loadVaccines(),
      child: const _VaccinesListView(),
    );
  }
}

class _VaccinesListView extends StatelessWidget {
  const _VaccinesListView();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Column(
            children: [
              // إصلاح ظهور العنوان
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TopBar(title: "قائمة التطعيمات"),
              ),

              // باقي الصفحة
              Expanded(
                child: BlocBuilder<VaccineCubit, VaccineState>(
                  builder: (context, state) {
                    if (state is VaccineLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is VaccineError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    } else if (state is VaccineLoaded1) {
                      final vaccines = state.vaccines;
                      final count = state.count;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // أزرار الإضافة
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: 'إضافة تطعيم جديد',
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<VaccineCubit>(
                                            create: (_) =>
                                                di<VaccineCubit>()..getStages(),
                                            child: AddVaccineScreen(),
                                          ),
                                        ),
                                      );

                                      if (result == true) {
                                        // هنا تعيد جلب التطعيمات (تحديث الشاشة)
                                        context
                                            .read<VaccineCubit>()
                                            .loadVaccines();
                                      }
                                    },
                                    textColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomButton(
                                    text: 'إضافة جرعة جديدة',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const AddDoseScreen()),
                                      );
                                    },
                                    textColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomButton(
                                    text: 'إضافة مرحلة جديدة',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const AddStageScreen()),
                                      );
                                    },
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'عدد التطعيمات: $count',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            const SizedBox(height: 16),

                            // إصلاح حاوية الجدول
                            Expanded(
                              child: Container(
                                width:
                                    double.infinity, // يجعلها تأخذ كامل العرض
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
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columnSpacing: 30,
                                    headingRowColor: MaterialStateProperty.all(
                                        Colors.grey.shade100),
                                    columns: const [
                                      DataColumn(label: Text('الاسم')),
                                      DataColumn(label: Text('الوصف')),
                                      DataColumn(label: Text('عدد الجرعات')),
                                      DataColumn(label: Text('الفئة')),
                                      DataColumn(label: Text('تاريخ الاضافه')),
                                      DataColumn(label: Text('إجراءات')),
                                    ],
                                    rows: vaccines.map((vaccine) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(vaccine.name)),
                                          DataCell(
                                              Text(vaccine.description ?? '-')),
                                          DataCell(Text(
                                              vaccine.doseCount.toString())),
                                          DataCell(Text(vaccine.category)),
                                          DataCell(const Text('2020\\12\\1')),
                                          DataCell(Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () async {
                                                  final result =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          EditVaccineScreen(
                                                              vaccineId:
                                                                  vaccine.id),
                                                    ),
                                                  );
                                                  if (result == true) {
                                                    context
                                                        .read<VaccineCubit>()
                                                        .loadVaccines();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'تم تعديل اللقاح')),
                                                    );
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  vaccine.status == 'active'
                                                      ? Icons.check_circle
                                                      : Icons.cancel,
                                                  color:
                                                      vaccine.status == 'active'
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<VaccineCubit>()
                                                      .toggleStatus(vaccine.id);
                                                },
                                              ),
                                            ],
                                          )),
                                        ],
                                      );
                                    }).toList(),
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
}
