// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_project/features/staff_management/logic/employee.state.dart';
// import 'package:new_project/features/staff_management/logic/employee_cubit.dart';

// class EmployeesScreen extends StatefulWidget {
//   const EmployeesScreen({super.key});

//   @override
//   State<EmployeesScreen> createState() => _EmployeesScreenState();
// }

// class _EmployeesScreenState extends State<EmployeesScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // نستخدم Future.microtask لضمان تنفيذها بعد اكتمال البناء الأولي
//     Future.microtask(() => context.read<EmployeeCubit>().fetchEmployeesList());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("قائمة الموظفين العامة")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocBuilder<EmployeeCubit, EmployeeState>(
//           builder: (context, state) {
//             print("Bloc State: $state"); // لتتبع الحالة الحالية

//             if (state is EmployeesListLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state is EmployeesListLoadedshow) {
//               final employees = state.employees;
//               print("عدد الموظفين المحمّلين: ${employees.length}");

//               final validatedEmployees = employees.map((emp) {
//                 // No need to parse if already DateTime
//                 return emp;
//               }).toList();

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "عدد الموظفين: ${validatedEmployees.length}",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // انتقل إلى شاشة إضافة موظف
//                     },
//                     child: const Text("إضافة موظف جديد"),
//                   ),
//                   const SizedBox(height: 16),
//                   // ...existing code...
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('الاسم الأول')),
//                         DataColumn(label: Text('الاسم الأخير')),
//                         DataColumn(label: Text('الجنس')),
//                         DataColumn(label: Text('البريد الإلكتروني')),
//                         DataColumn(label: Text('المركز الصحي')),
//                         DataColumn(label: Text('الحالة')),
//                         DataColumn(label: Text('الإجراءات')),
//                       ],
//                       rows: employees.map((emp) {
//                         return DataRow(
//                           cells: [
//                             DataCell(Text(emp.first_name ?? '')),
//                             DataCell(Text(emp.last_name ?? '')),
//                             DataCell(Text(emp.gender ?? '')),
//                             DataCell(Text(emp.email ?? '')),
//                             DataCell(Text(emp.healthCenterName ??
//                                 '')), // تأكد من وجود هذا الحقل في الموديل
//                             DataCell(Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: emp.isActive == 1
//                                     ? Colors.green
//                                     : Colors.grey,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Text(
//                                 emp.isActive == 1 ? "نشط" : "غير نشط",
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             )),
//                             DataCell(Row(
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.visibility),
//                                   onPressed: () {
//                                     // تفاصيل
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.edit),
//                                   onPressed: () {
//                                     // تعديل
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete,
//                                       color: Colors.red),
//                                   onPressed: () {
//                                     // حذف
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(
//                                     emp.isActive == 1
//                                         ? Icons.toggle_on
//                                         : Icons.toggle_off,
//                                     color: emp.isActive == 1
//                                         ? Colors.green
//                                         : Colors.grey,
//                                   ),
//                                   onPressed: () {
//                                     // تفعيل/تعطيل
//                                   },
//                                 ),
//                               ],
//                             )),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               );
//             }
//             // Default fallback widget if state is neither loading nor loaded
//             return const Center(child: Text('لا توجد بيانات متاحة'));
//           },
//         ),
//       ),
//     );
//   }
// // ...existing code...

//   // دالة للتحقق من صحة التواريخ
//   DateTime _parseDate(String? date) {
//     if (date == null) return DateTime.now(); // أو يمكن وضع تاريخ آخر مناسب
//     try {
//       return DateTime.parse(date);
//     } catch (e) {
//       return DateTime
//           .now(); // إذا كانت البيانات غير صحيحة، استخدم التاريخ الحالي
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/theme/colors.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  // بيانات وهمية مؤقتة
  List<EmployeeModel> get employees => [
        EmployeeModel(
          id: 1,
          first_name: 'أحمد',
          last_name: 'الزهراني',
          gender: 'ذكر',
          email: 'ahmed@example.com',
          phone_number: '0500000000',
          identity_card_number: '1234567890',
          nationalities_id: 1,
          location_id: 1,
          role: 'مدير',
          date_of_birth: DateTime(1990, 5, 10),
          employment_date: DateTime(2020, 1, 1),
          isActive: 1,
          health_center_id: 2,
        ),
        EmployeeModel(
          id: 2,
          first_name: 'سارة',
          last_name: 'الخطيب',
          gender: 'أنثى',
          email: 'sara@example.com',
          phone_number: '0501111111',
          identity_card_number: '9876543210',
          nationalities_id: 2,
          location_id: 2,
          role: 'ممرضة',
          date_of_birth: DateTime(1995, 8, 15),
          employment_date: DateTime(2021, 3, 20),
          isActive: 0,
          health_center_id: 1,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Row(
          children: [
            const SizedBox(width: 300, child: SideNav()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBar(title: "قائمة الموظفين"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('الاسم الأول')),
                            DataColumn(label: Text('الاسم الأخير')),
                            DataColumn(label: Text('الجنس')),
                            DataColumn(label: Text('البريد الإلكتروني')),
                            DataColumn(label: Text('رقم المركز الصحي')),
                            DataColumn(label: Text('الحالة')),
                            DataColumn(label: Text('إجراءات')),
                          ],
                          rows: employees.map((EmployeeModel emp) {
                            return DataRow(
                              cells: [
                                DataCell(Text(emp.first_name.isNotEmpty
                                    ? emp.first_name
                                    : 'غير محدد')),
                                DataCell(Text(emp.last_name.isNotEmpty
                                    ? emp.last_name
                                    : 'غير محدد')),
                                DataCell(Text(emp.gender.isNotEmpty
                                    ? emp.gender
                                    : 'غير محدد')),
                                DataCell(Text(
                                    (emp.email != null && emp.email!.isNotEmpty)
                                        ? emp.email!
                                        : 'غير محدد')),
                                DataCell(Text(emp.health_center_id != null
                                    ? emp.health_center_id.toString()
                                    : '-')),
                                DataCell(Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: emp.isActive == 1
                                        ? Colors.green
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    emp.isActive == 1 ? "نشط" : "غير نشط",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        // TODO: تنفيذ التعديل
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        // TODO: تنفيذ الحذف
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
            ),
          ],
        ),
      ),
    );
  }
}
