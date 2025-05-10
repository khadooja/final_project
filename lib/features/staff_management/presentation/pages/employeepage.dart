/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/commn_widgets/sidebar.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
//import 'package:new_project/features/staff_management/domain/entities/employee.dart';
import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:new_project/features/staff_management/domain/usecases/add_employee.dart';
import 'package:new_project/features/staff_management/domain/usecases/check_person_existence.dart';
import 'package:new_project/features/staff_management/presentation/pages/view_employees_page.dart';
import 'package:new_project/features/staff_management/presentation/widget/employeestable.dart';
import 'package:new_project/features/staff_management/presentation/widget/mainheader.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final adminBloc = AdminBloc(
          repository: GetIt.instance<AdminRepository>(),
          checkPersonExistence: GetIt.instance<CheckPersonExistence>(),
          addEmployee: GetIt.instance<AddEmployee>(),
        );
        adminBloc.add(const FetchEmployeesWithPaginationEvent(page: null));
        return adminBloc;
      },
      child: Scaffold(
        body: Row(
          children: [
            const Sidebar(
              menuItems: [],
              userName: 'koko',
              userRole: 'employee',
            ),
            Expanded(
              child: Column(
                children: [
                  const MainHeader(title: "قائمة الموظفين"),
                  Expanded(
                    child: BlocBuilder<AdminBloc, AdminState>(
                      builder: (context, state) {
                        if (state is AdminLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is AdminError) {
                          return Center(child: Text(state.message));
                        } else if (state is EmployeesLoadedWithPagination) {
                          return EmployeesTable(
                            employees: state.employees.map((employee) {
                              // هنا يمكنك إجراء التحويل اليدوي إذا كانت "EmployeeDeactivated" تحتوي على بيانات مطابقة.
                              return EmployeeModel(
                                id: employee.id,
                                employmentDate: DateTime.now(),
                                dateOfBirth: DateTime.now(),
                                healthCenterId: employee.healthCenterId,
                                isActive: false,
                              );
                            }).toList(),
                            currentPage: state.currentPage,
                            totalPages: state.totalPages,
                            onPageChanged: (page) {
                              context.read<AdminBloc>().add(
                                  FetchEmployeesWithPaginationEvent(
                                      page: page));
                            },
                            onEdit: (employee) {
                              // توجيه المستخدم إلى صفحة عرض تفاصيل الموظف
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewEmployeesPage(
                                    //employees: [],
                                    selectedFunction: 'عرض موظفين',
                                    username: '',
                                    useremail:
                                        '', // اختيار الوظيفة من السياق أو حالة معينة
                                  ),
                                ),
                              );
                            },
                            onDeactivate: (employee) {
                              // هنا يمكننا إظهار حوار تأكيد قبل تعطيل الموظف
                              _showDeactivateConfirmationDialog(
                                  context, employee);
                            },
                            persons: const [],
                            //maxRows: 5,
                          );
                        }
                        return const SizedBox();
                      },
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

  void _showDeactivateConfirmationDialog(
      BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("تأكيد تعطيل الموظف"),
          content:
              Text("هل أنت متأكد من أنك تريد تعطيل الموظف ${employee.id}؟"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                // تنفيذ عملية تعطيل الموظف هنا
                context
                    .read<AdminBloc>()
                    .add(DeactivateEmployeeEvent(employee as String));
                Navigator.pop(context);
              },
              child: const Text("تعطيل"),
            ),
          ],
        );
      },
    );
  }
}
*/