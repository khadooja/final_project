import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/data/model/dropdownclass.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class EmployeeRegistrationForm extends StatefulWidget {
  final PersonModel? personData;
  final DropdownData? dropdownData;

  const EmployeeRegistrationForm({
    super.key,
    this.personData,
    this.dropdownData,
    EmployeeModel? employeeData,
  });

  @override
  State<EmployeeRegistrationForm> createState() =>
      _EmployeeRegistrationFormState();
}

class _EmployeeRegistrationFormState extends State<EmployeeRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController idNumberController;
  late TextEditingController emailController;
  late TextEditingController birthDateController;
  late TextEditingController phoneController;
  late TextEditingController hireDateController;
  int? selectedHealthCenterId;
  int? selectedJobTitleId;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _prefillDataIfExists();
  }

  void _initializeControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    idNumberController = TextEditingController();
    emailController = TextEditingController();
    birthDateController = TextEditingController();
    phoneController = TextEditingController();
    hireDateController = TextEditingController();
  }

  void _prefillDataIfExists() {
    if (widget.personData != null) {
      firstNameController.text = widget.personData!.firstName ?? '';
      lastNameController.text = widget.personData!.lastName ?? '';
      idNumberController.text = (widget.personData!.nationalitiesId).toString();
      emailController.text = widget.personData!.email ?? '';
      birthDateController.text = widget.personData!.birthDate?.toString() ?? '';
      phoneController.text = widget.personData!.phoneNumber ?? '';
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = picked.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // حقول البيانات الأساسية
            TextFormField(
              controller: idNumberController,
              decoration: const InputDecoration(labelText: 'رقم الهوية'),
              enabled: widget.personData == null,
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'الاسم الأول'),
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'اسم العائلة'),
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),
            TextFormField(
              controller: birthDateController,
              decoration: const InputDecoration(labelText: 'تاريخ الميلاد'),
              onTap: () => _selectDate(context, birthDateController),
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),

            // حقول التوظيف (للموظفين فقط)
            if (widget.personData != null) ...[
              const SizedBox(height: 20),
              const Text('بيانات التوظيف', style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: hireDateController,
                decoration: const InputDecoration(labelText: 'تاريخ التوظيف'),
                onTap: () => _selectDate(context, hireDateController),
                validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
              ),
              DropdownButtonFormField<int>(
                value: selectedHealthCenterId,
                decoration: const InputDecoration(labelText: 'المركز الصحي'),
                items: widget.dropdownData?.healthCenters
                    .map((center) => DropdownMenuItem(
                          value: center.id,
                          child: Text(center.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedHealthCenterId = value),
                validator: (value) => value == null ? 'مطلوب' : null,
              ),
              DropdownButtonFormField<int>(
                value: selectedJobTitleId,
                decoration: const InputDecoration(labelText: 'المسمى الوظيفي'),
                items: widget.dropdownData?.positions
                    .map((title) => DropdownMenuItem(
                          value: title.id,
                          child: Text(title.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedJobTitleId = value),
                validator: (value) => value == null ? 'مطلوب' : null,
              ),
            ],

            // زر الحفظ
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('حفظ البيانات'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final employeeData = {
        'person_data': {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'nationality_id': idNumberController.text,
          'email': emailController.text,
          'date_of_birth': birthDateController.text,
          'phone_number': phoneController.text,
        },
        'employment_data': widget.personData != null
            ? {
                'hire_date': hireDateController.text,
                'health_center_id': selectedHealthCenterId,
                'job_title_id': selectedJobTitleId,
              }
            : null,
      };

      final bloc = context.read<AdminBloc>();
      bloc.add(AddEmployeeEvent(
        isPersonExist: widget.personData != null,
        employeeData: employeeData,
      ));
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    idNumberController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    hireDateController.dispose();
    super.dispose();
  }
}
