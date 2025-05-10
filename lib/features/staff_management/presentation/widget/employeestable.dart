/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/generic_table.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
//import 'package:new_project/features/staff_management/domain/entities/employee.dart';
//import 'package:new_project/features/staff_management/domain/entities/person.dart';
import 'package:new_project/features/staff_management/presentation/pages/editemployee.dart';

class EmployeesTable extends GenericTable<EmployeeModel> {
  final Function(EmployeeModel) onEdit;
  final Function(EmployeeModel) onDeactivate;

  EmployeesTable({
    super.key,
    required List<EmployeeModel> employees,
    required List<EmployeeModel> persons,
    required super.currentPage,
    required super.totalPages,
    required super.onPageChanged,
    required this.onEdit,
    required this.onDeactivate,
  }) : super(
          columnNames: [
            "الاسم الأول",
            "الاسم الأخير",
            "البريد الإلكتروني",
            "الجنس",
            "الحالة",
            "الإجراءات"
          ],
          data: employees,
          buildRow: _buildEmployeeRow,
        );

  static Widget _buildEmployeeRow(
      BuildContext context, EmployeeModel employee) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is EmployeeUpdatedSuccessfully &&
            state.employees.any((e) => e.id == employee.id)) {
          employee = state.employees.firstWhere((e) => e.id == employee.id);
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            color: employee.isActive ? null : Colors.grey[200],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCell(
                  employee.personData?.firstName ?? "",
                  width: 320,
                  isActive: employee.isActive,
                ),
                _buildCell(
                  employee.personData?.lastName ?? "",
                  width: 120,
                  isActive: employee.isActive,
                ),
                _buildCell(
                  employee.personData?.email ?? "",
                  width: 320,
                  isActive: employee.isActive,
                ),
                _buildCell(
                  employee.personData?.gender ?? "",
                  width: 120,
                  isActive: employee.isActive,
                ),
                const SizedBox(width: 16),
                _buildStatusCell(employee.isActive),
                const SizedBox(width: 16),
                _buildActions(context, employee),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildCell(
    String text, {
    required double width,
    required bool isActive,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            decoration: isActive ? null : TextDecoration.lineThrough,
            color: isActive ? Colors.black : Colors.grey,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  static Widget _buildStatusCell(bool isActive) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              isActive ? "نشط" : "غير نشط",
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildActions(BuildContext context, EmployeeModel employee) {
    return BlocConsumer<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is AdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // زر التعديل
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                onPressed: () => _onEditPressed(context, employee),
              ),
              IconButton(
                icon: Icon(Icons.block,
                    size: 20,
                    color: employee.isActive ? Colors.red : Colors.grey),
                onPressed: () {
                  final updatedEmployee =
                      employee.copyWith(isActive: !employee.isActive);

                  context.read<AdminBloc>().add(
                        UpdateEmployeeEvent(updatedEmployee),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(updatedEmployee.isActive
                          ? "تم تفعيل الموظف"
                          : "تم تعطيل الموظف"),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void _onEditPressed(BuildContext context, EmployeeModel employee) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditEmployeePage(employee: employee),
        fullscreenDialog: true,
      ),
    )
        .then((updated) {
      if (updated != null && updated == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم تحديث بيانات الموظف بنجاح")),
        );
      }
    });
  }

  static void _onToggleStatus(BuildContext context, EmployeeModel employee) {
    final updatedEmployee = employee.copyWith(isActive: !employee.isActive);

    context.read<AdminBloc>().add(
          UpdateEmployeeEvent(updatedEmployee), // استخدام Model مباشرة
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(updatedEmployee.isActive
            ? "تم تفعيل الموظف بنجاح"
            : "تم تعطيل الموظف بنجاح"),
      ),
    );
  }
}
*/