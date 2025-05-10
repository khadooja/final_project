/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/employeeSearchManager.dart';
import 'package:new_project/core/commn_widgets/sideNav.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/presentation/pages/add_employee_page.dart';
import 'package:new_project/features/staff_management/presentation/pages/view_employees_page.dart';
import 'package:new_project/Core/commn_widgets/sideNav.dart';

class EmployeesPageContent extends StatefulWidget {
  final String? username;
  final String? useremail;

  const EmployeesPageContent({
    super.key,
    required this.username,
    required this.useremail,
  });

  @override
  _EmployeesPageContentState createState() => _EmployeesPageContentState();
}

class _EmployeesPageContentState extends State<EmployeesPageContent> {
  int selectedIndex = 0; // 0: إضافة موظف, 1: عرض الموظفين
  late EmployeeSearchManager searchManager;

  @override
  void initState() {
    super.initState();
    searchManager = EmployeeSearchManager(context.read<AdminBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // القائمة الجانبية
          SizedBox(
            width: 250, // تقليل العرض قليلاً لجعل التصميم أكثر احترافية
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Sidenav(
                selectedFunction:
                    selectedIndex == 0 ? "إضافة موظف" : "عرض الموظفين",
                onFunctionSelected: (function) {
                  setState(() {
                    selectedIndex = function == "إضافة موظف" ? 0 : 1;
                  });
                },
                functions: const ["إضافة موظف", "عرض الموظفين"],
                userName: widget.username ?? "غير معروف",
                userEmail: widget.useremail ?? "غير معروف",
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [
                // صفحة إضافة الموظف
                AddEmployeePage(
                  username: widget.username ?? "",
                  useremail: widget.useremail ?? "",
                ),
                // صفحة عرض الموظفين
                const ViewEmployeesPage(
                  username: '',
                  useremail: '',
                  selectedFunction: "عرض الموظفين",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
