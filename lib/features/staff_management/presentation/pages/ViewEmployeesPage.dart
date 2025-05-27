import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/staff_management/logic/employee.state.dart';
import 'package:new_project/features/staff_management/logic/employee_cubit.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  @override
  void initState() {
    super.initState();
    // نستخدم Future.microtask لضمان تنفيذها بعد اكتمال البناء الأولي
    Future.microtask(() => context.read<EmployeeCubit>().fetchEmployeesList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("قائمة الموظفين العامة")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            print("Bloc State: $state"); // لتتبع الحالة الحالية

            if (state is EmployeesListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmployeesListLoaded) {
              final employees = state.employees;
              print("عدد الموظفين المحمّلين: ${employees.length}");

              // التحقق من صحة التواريخ وبيانات الموظفين قبل العرض
              final validatedEmployees = employees.map((emp) {
                // No need to parse if already DateTime
                return emp;
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "عدد الموظفين: ${validatedEmployees.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // انتقل إلى شاشة إضافة موظف
                    },
                    child: const Text("إضافة موظف جديد"),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: validatedEmployees.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final emp = validatedEmployees[index];
                        final isInactive = emp.isActive == 0;

                        return ListTile(
                          leading: Icon(
                            Icons.person,
                            color: isInactive ? Colors.grey : Colors.blue,
                          ),
                          title: Row(
                            children: [
                              Text("${emp.first_name} ${emp.last_name}"),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isInactive ? Colors.grey : Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isInactive ? "غير نشط" : "نشط",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          subtitle: Text(
                            "${emp.email ?? ''} - المركز الصحي: ${emp.health_center_id ?? '-'}",
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  // عرض التفاصيل
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // تعديل الموظف
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // حذف الموظف
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  isInactive ? Icons.toggle_off : Icons.toggle_on,
                                  color: isInactive ? Colors.grey : Colors.green,
                                ),
                                onPressed: () {
                                  // تفعيل/تعطيل الموظف
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is EmployeesListError) {
              return Center(child: Text("حدث خطأ أثناء تحميل البيانات: ${state.message}"));
            }

            // الحالة الافتراضية
            return const Center(child: Text("لا توجد بيانات حالياً."));
          },
        ),
      ),
    );
  }

  // دالة للتحقق من صحة التواريخ
  DateTime _parseDate(String? date) {
    if (date == null) return DateTime.now(); // أو يمكن وضع تاريخ آخر مناسب
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime.now(); // إذا كانت البيانات غير صحيحة، استخدم التاريخ الحالي
    }
  }
}
