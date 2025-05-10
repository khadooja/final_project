/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/header.dart';
import 'package:new_project/Core/commn_widgets/personalCheckWidget.dart';
import 'package:new_project/Core/commn_widgets/sideNav.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/presentation/pages/view_employees_page.dart';
import 'package:new_project/features/staff_management/presentation/widget/add_employee_form.dart';

class AddEmployeePage extends StatefulWidget {
  final String username;
  final String useremail;

  const AddEmployeePage({
    super.key,
    required this.username,
    required this.useremail,
  });

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  late TextEditingController idController;
  EmployeeModel? employeeData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<AdminBloc>().add(const FetchDropdownDataEvent());
    setState(() => _isLoading = false);
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
          // Sidebar
          SizedBox(
            width: 250,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Sidenav(
                onFunctionSelected: _handleFunctionSelectionWrapper,
                functions: const ["إضافة موظف", "عرض الموظفين"],
                selectedFunction: "إضافة موظف",
                userName: widget.username,
                userEmail: widget.useremail,
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSearchSection(),
                  const SizedBox(height: 16),
                  _buildFormSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return EmployeeSearchScreen(
      idController: idController,
      onPersonFound: (employee) {
        setState(() {
          employeeData = employee;
          _isLoading = false;
        });
      },
      onPersonNotFound: () {
        setState(() {
          employeeData = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لم يتم العثور على الموظف')),
          );
        });
      },
      buildPersonnelForm: () {
        return const EmployeeRegistrationForm();
      },
      buildFullForm: () {
        return const EmployeeRegistrationForm();
      },
    );
  }

  Widget _buildFormSection() {
    return Expanded(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : BlocConsumer<AdminBloc, AdminState>(
                listener: (context, state) {
                  if (state is AdminError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  // ← أضف هذه الكتلة
                  if (state is DropdownDataLoaded) {
                    if (state.dropdownData.healthCenters.isEmpty ||
                        state.dropdownData.positions.isEmpty) {
                      return const Center(child: Text('لا توجد بيانات متاحة'));
                    }

                    if (employeeData == null) {
                      return const Center(
                          child: Text('الرجاء البحث عن موظف أولاً'));
                    }

                    return EmployeeRegistrationForm(
                      employeeData: employeeData!,
                      dropdownData: state.dropdownData,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ));
  }

  void _handleFunctionSelection(BuildContext context, String function) {
    if (function == "عرض الموظفين") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewEmployeesPage(
            username: widget.username,
            useremail: widget.useremail,
            selectedFunction: function,
          ),
        ),
      );
    }
  }

  void _handleFunctionSelectionWrapper(String function) {
    _handleFunctionSelection(context, function);
  }
}
*/