import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
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
        child: TopBar(
          title: 'إضافة موظف',
        ),
      ),
      body: Row(
        children: [
          // Sidebar
          const SizedBox(
            width: 250,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SideNav(
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
      onPersonFound: (EmployeeModel employee) {
        setState(() {
          employeeData = employee;
        });
      },
      onPersonNotFound: () {
        setState(() {
          employeeData = null;
        });
      },
      buildPersonnelForm: () => const SizedBox.shrink(),
      buildFullForm: () => const SizedBox.shrink(),
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
          builder: (context) => const EmployeeRegistrationForm(), // استبدل هذا بالصفحة المناسبة لعرض الموظفين
        ),
      );
    }
  }

  void _handleFunctionSelectionWrapper(String function) {
    _handleFunctionSelection(context, function);
  }
}

class EmployeeSearchScreen extends StatelessWidget {
  final TextEditingController idController;
  final Function(EmployeeModel) onPersonFound;
  final Function() onPersonNotFound;
  final Widget Function() buildPersonnelForm;
  final Widget Function() buildFullForm;

  const EmployeeSearchScreen({
    super.key,
    required this.idController,
    required this.onPersonFound,
    required this.onPersonNotFound,
    required this.buildPersonnelForm,
    required this.buildFullForm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: idController,
          decoration: const InputDecoration(
            labelText: 'البحث برقم الهوية',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // هنا يمكنك إضافة منطق البحث عن الموظف
            // إذا تم العثور على الموظف، استدعِ onPersonFound
            // وإذا لم يتم العثور عليه، استدعِ onPersonNotFound
          },
          child: const Text('بحث'),
        ),
      ],
    );
  }
}

