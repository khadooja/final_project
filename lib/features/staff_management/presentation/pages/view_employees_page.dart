/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/header.dart';
import 'package:new_project/Core/commn_widgets/sideNav.dart';
import 'package:new_project/core/commn_widgets/sideNav.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

//import 'package:new_project/features/staff_management/domain/entities/employee.dart';
import 'package:new_project/features/staff_management/presentation/pages/add_employee_page.dart';
import 'package:new_project/features/staff_management/presentation/pages/editemployee.dart';
import 'package:new_project/features/staff_management/presentation/widget/employeestable.dart';

class ViewEmployeesPage extends StatefulWidget {
  final String username;
  final String useremail;

  const ViewEmployeesPage({
    super.key,
    required this.username,
    required this.useremail,
    required String selectedFunction,
  });

  @override
  _ViewEmployeesPageState createState() => _ViewEmployeesPageState();
}

class _ViewEmployeesPageState extends State<ViewEmployeesPage> {
  int currentPage = 1;
  int totalPages = 5;
  List<EmployeeModel> employees = [];

  @override
  @override
  void initState() {
    super.initState();
    if (context.read<AdminBloc>().state is! EmployeesLoaded) {
      print(
          "..................................................................................");
      context.read<AdminBloc>().add(FetchEmployeesEvent());
    }
  }

  //context.read<AdminBloc>().add(FetchEmployeesEvent());
  void _loadEmployees() {
    //context.read<AdminBloc>().add(FetchEmployeesEvent());
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        employees = [
          EmployeeModel(
            id: 1,
            employmentDate: DateTime.now(),
            dateOfBirth: DateTime(1990, 1, 1),
            healthCenterId: 1,
            isActive: true,
          ),
          EmployeeModel(
            id: 1,
            employmentDate: DateTime.now(),
            dateOfBirth: DateTime(1990, 1, 1),
            healthCenterId: 11,
            isActive: true,
          ),
          EmployeeModel(
            id: 1,
            employmentDate: DateTime.now(),
            dateOfBirth: DateTime(1990, 1, 1),
            healthCenterId: 11,
            isActive: true,
          ),
          // إضافة بيانات أكثر عند الحاجة
        ];
        totalPages = 1;
        print(
            "✅ EmployeesLoaded وصل بنجاح، عدد الموظفين: ${employees.length}........................................");
      });
    });
  }

  void _navigateToAddEmployee() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeePage(
          username: widget.username,
          useremail: widget.useremail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      body: Row(
        children: [
          // النافذة الجانبية (ثابتة العرض)
          SizedBox(
            width: 250,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Sidenav(
                onFunctionSelected: _handleFunctionSelection,
                functions: const [
                  "إضافة موظف",
                  "عرض الموظفين",
                  "إضافة أطفال",
                  "عرض الأطفال"
                ],
                selectedFunction: 'عرض الموظفين',
                userName: widget.username,
                userEmail: widget.useremail,
              ),
            ),
          ),

          // الجزء الرئيسي (جدول الموظفين)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // عنوان الصفحة
                  const Text(
                    "قائمة الموظفين",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Expanded(
                    child: BlocBuilder<AdminBloc, AdminState>(
                      builder: (context, state) {
                        if (state is AdminLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is EmployeesLoaded ||
                            state is EmployeeUpdatedSuccessfully) {
                          // استخراج البيانات من أي حالة
                          final employees = (state is EmployeesLoaded)
                              ? state.employees
                              : (state as EmployeeUpdatedSuccessfully)
                                  .employees;

                          if (employees.isEmpty) {
                            return const Center(
                                child: Text("لا يوجد موظفين متاحين"));
                          }

                          return EmployeesTable(
                            employees: employees.map((e) => e).toList(),
                            currentPage: currentPage,
                            totalPages: totalPages,
                            onPageChanged: (page) {
                              setState(() {
                                currentPage = page;
                              });
                            },
                            onEdit: (employee) {
                              _showEditDialog(context, employee);
                            },
                            onDeactivate: (employee) {
                              final updatedEmployee = employee.copyWith(
                                isActive: !employee.isActive,
                              );
                              context
                                  .read<AdminBloc>()
                                  .add(UpdateEmployeeEvent(updatedEmployee));
                            },
                            persons: const [],
                          );
                        } else if (state is AdminError) {
                          return Center(child: Text("❌ خطأ: ${state.message}"));
                        }
                        return const Center(
                            child: Text("⚠️ لا توجد بيانات متاحة"));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFunctionSelection(String function) {
    switch (function) {
      case "إضافة موظف":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEmployeePage(
              username: widget.username,
              useremail: widget.useremail,
            ),
          ),
        );
        break;
      case "عرض الموظفين":
        break;
      default:
        break;
    }
  }

  void _showEditDialog(BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 600,
          //child: EditEmployeePage(employee: employee),
        ),
      ),
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تعديل الموظف بنجاح!")),
      );
      context.read<AdminBloc>().add(FetchEmployeesEvent());
    });
  }
}
*/