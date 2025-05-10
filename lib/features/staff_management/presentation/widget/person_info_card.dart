import 'package:flutter/material.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
//import 'package:new_project/features/staff_management/domain/entities/employee.dart';

class PersonInfoCard extends StatelessWidget {
  const PersonInfoCard({super.key, required EmployeeModel employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات الشخص',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('الاسم', 'محمد صالح'),
            _buildInfoRow('رقم الهوية', '1234567890'),
            _buildInfoRow('الجنسية', 'يمني'),
            _buildInfoRow('تاريخ الميلاد', '01/01/1990'),
            _buildInfoRow('رقم الهاتف', '123456789'),
            _buildInfoRow('العنوان', 'شارع السلام، صنعاء'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
