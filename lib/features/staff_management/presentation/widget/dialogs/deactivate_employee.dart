import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
//import 'package:new_project/features/staff_management/domain/entities/employee.dart';

class DeactivateEmployeeDialog extends StatelessWidget {
  final EmployeeModel employee;

  const DeactivateEmployeeDialog({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is EmployeeDeactivated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تعطيل الموظف بنجاح')),
          );
          Navigator.pop(context); // إغلاق الـ Dialog بعد نجاح العملية
        }
      },
      child: AlertDialog(
        title: const Text('تعطيل الموظف'),
        content: const Text('هل أنت متأكد من رغبتك في تعطيل هذا الموظف؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<AdminBloc>()
                  .add(DeactivateEmployeeEvent(employee.id.toString()));
            },
            child: const Text('تعطيل'),
          ),
        ],
      ),
    );
  }
}
