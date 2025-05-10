import 'package:flutter/material.dart';

class EmployeeFormFields extends StatelessWidget {
  final TextEditingController controllerFirstName;
  final TextEditingController controllerLastName;
  final TextEditingController controllerEmail;
  final TextEditingController controllerBirthDate;
  final TextEditingController controllerPhone;
  final TextEditingController controllerIDNumber;
  final TextEditingController controllerHireDate;

  const EmployeeFormFields({
    super.key,
    required this.controllerFirstName,
    required this.controllerLastName,
    required this.controllerEmail,
    required this.controllerBirthDate,
    required this.controllerPhone,
    required this.controllerIDNumber,
    required this.controllerHireDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controllerIDNumber,
          decoration: const InputDecoration(labelText: 'رقم الهوية'),
        ),
        TextFormField(
          controller: controllerFirstName,
          decoration: const InputDecoration(labelText: 'الاسم الأول'),
        ),
        TextFormField(
          controller: controllerLastName,
          decoration: const InputDecoration(labelText: 'اسم العائلة'),
        ),
        TextFormField(
          controller: controllerEmail,
          decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
        ),
        TextFormField(
          controller: controllerBirthDate,
          decoration: const InputDecoration(labelText: 'تاريخ الميلاد'),
        ),
        TextFormField(
          controller: controllerPhone,
          decoration: const InputDecoration(labelText: 'رقم الهاتف'),
        ),
        TextFormField(
          controller: controllerHireDate,
          decoration: const InputDecoration(labelText: 'تاريخ التوظيف'),
        ),
      ],
    );
  }
}
