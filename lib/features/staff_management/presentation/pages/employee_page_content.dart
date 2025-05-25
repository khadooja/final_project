import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/features/staff_management/presentation/pages/add_employee_page.dart';

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
  late AddEmployeePage searchManager;

  @override
  void initState() {
    super.initState();
   // searchManager = AddEmployeePage(context.read<AdminBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // القائمة الجانبية
          const SizedBox(
            width: 250, // تقليل العرض قليلاً لجعل التصميم أكثر احترافية
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SideNav(
                
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
                const AddEmployeePage(
                  username: '',
                  useremail: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
