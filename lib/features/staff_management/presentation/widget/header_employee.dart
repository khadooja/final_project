import 'package:flutter/material.dart';

class EmployeesHeader extends StatelessWidget {
  final int totalEmployees;

  const EmployeesHeader({super.key, required this.totalEmployees});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'عدد الموظفين: $totalEmployees',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/add_employee'),
            icon: const Icon(Icons.add),
            label: const Text('إضافة موظف'),
          ),
        ],
      ),
    );
  }
}
