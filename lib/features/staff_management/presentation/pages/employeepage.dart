import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/commn_widgets/sidebar.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
//import 'package:new_project/features/staff_management/domain/entities/employee.dart';
import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:new_project/features/staff_management/domain/usecases/add_employee.dart';
import 'package:new_project/features/staff_management/domain/usecases/check_person_existence.dart';
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
                          return Text( state.employees.isEmpty
                              ? "لا توجد موظفين"
                              : "عدد الموظفين: ${state.employees.length}");
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
