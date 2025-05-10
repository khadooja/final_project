/*import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/Core/networking/locationService.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class EditEmployeePage extends StatefulWidget {
  final EmployeeModel employee;

  const EditEmployeePage({super.key, required this.employee});

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _employmentDateController;
  late TextEditingController _birthDateController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _locationController;
  late TextEditingController _centerController;
  late TextEditingController _genderController;
  late TextEditingController _idNumberController;
  late String? _selectedNationalityId;
  String? _selectedCity;
  String? _selectedArea;
  String? _selectedStatus;
  final List<String> nationalities = ["سعودي", "يمني", "مصري", "سوري"];
  final List<String> statuses = ["نشط", "غير نشط"];
  List<String> cities = [];
  List<String> areas = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _selectedStatus = widget.employee.isActive ? "نشط" : "غير نشط";
    _loadCities();
  }

  void _initializeControllers() {
    _firstnameController =
        TextEditingController(text: widget.employee.personData?.firstName);
    _lastnameController =
        TextEditingController(text: widget.employee.personData?.lastName);
    _emailController =
        TextEditingController(text: widget.employee.personData?.email);
    _phoneNumberController =
        TextEditingController(text: widget.employee.personData?.phoneNumber);
    _employmentDateController = TextEditingController(
      text: _formatDate(widget.employee.employmentDate),
    );
    _birthDateController = TextEditingController(
      text: _formatDate(widget.employee.dateOfBirth),
    );
    _locationController = TextEditingController();
    _centerController =
        TextEditingController(text: widget.employee.healthCenterId.toString());
    _genderController =
        TextEditingController(text: widget.employee.personData?.gender);
    _idNumberController = TextEditingController(
        text: widget.employee.personData?.identityCardNumber);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadCities() async {
    try {
      final locations = await LocationService(dio: Dio()).fetchAllLocations();
      setState(() {
        cities = locations.cast<String>();
        if (cities.isNotEmpty) {
          _selectedCity = cities.first;
          _loadAreas(_selectedCity!);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل المدن: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadAreas(String city) async {
    try {
      final areasList = await LocationService(dio: Dio()).getAreasByCity(city);
      setState(() {
        areas = areasList.cast<String>();
        if (areas.isNotEmpty) {
          _selectedArea = areas.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل الأحياء: ${e.toString()}')),
      );
    }
  }

  void _updateEmployee() {
    if (_formKey.currentState!.validate()) {
      final updatedEmployee = EmployeeModel(
        id: widget.employee.id,
        employmentDate: DateTime.parse(_employmentDateController.text),
        dateOfBirth: DateTime.parse(_birthDateController.text),
        isActive: _selectedStatus == "نشط",
        healthCenterId: int.parse(_centerController.text),
        personData: PersonModel(
          id: int.tryParse(widget.employee.personData?.id.toString() ?? '0') ??
              0,
          firstName: _firstnameController.text,
          lastName: _lastnameController.text,
          email: _emailController.text,
          birthDate: DateTime.parse(
              _birthDateController.text), // Use the new birthDate parameter
          phoneNumber: _phoneNumberController.text,
          locationId: int.tryParse(_locationController.text) ?? 0,
          gender: _genderController.text,
          identityCardNumber: _idNumberController.text,
          nationalitiesId: int.tryParse(_selectedNationalityId ?? '0') ?? 0,
        ),
      );

      context.read<AdminBloc>().add(
            UpdateEmployeeEvent(updatedEmployee),
          );
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _employmentDateController.dispose();
    _birthDateController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    _centerController.dispose();
    _genderController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is EmployeeUpdatedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تعديل الموظف بنجاح!")),
          );
          Navigator.pop(context, true);
        } else if (state is AdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("تعديل بيانات الموظف")),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // حقول الإدخال
                CustomInputField(
                  label: "الاسم الأول",
                  controller: _firstnameController,
                  validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  label: "الاسم الأخير",
                  controller: _lastnameController,
                  validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // ... باقي حقول الإدخال بنفس النمط

                // Dropdowns
                CustomInputField(
                  label: "الجنسية",
                  keyboardType: InputType.dropdown,
                  dropdownItems: nationalities,
                  selectedValue: _selectedNationalityId,
                  onChanged: (val) =>
                      setState(() => _selectedNationalityId = val),
                ),
                const SizedBox(height: 16),

                // ... باقي العناصر بنفس النمط

                // أزرار الحفظ والإلغاء
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updateEmployee,
                        child: const Text("حفظ التعديلات"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        child: const Text("إلغاء"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
