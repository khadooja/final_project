/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/guardian_management.dart/logic/guardian_cubit.dart';

class GuardianFormSection extends StatelessWidget {
  const GuardianFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GuardianCubit>();

    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cubit.firstNameController,
                    decoration: const InputDecoration(labelText: 'الاسم الأول'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: cubit.lastNameController,
                    decoration:
                        const InputDecoration(labelText: 'الاسم الأخير'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cubit.identityController,
                    decoration: const InputDecoration(labelText: 'رقم الهوية'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: cubit.birthDateController,
                    decoration:
                        const InputDecoration(labelText: 'تاريخ الميلاد'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cubit.phoneController,
                    decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: cubit.emailController,
                    decoration:
                        const InputDecoration(labelText: 'البريد الإلكتروني'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: cubit.addressController,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('الجنس:'),
                Radio<int>(
                  value: 1,
                  groupValue: int.tryParse(cubit.selectedGender ?? ''),
                  onChanged: (value) {
                    cubit.selectedGender = value.toString();
                  },
                ),
                const Text('ذكر'),
                Radio<int>(
                  value: 2,
                  groupValue: int.tryParse(cubit.selectedGender ?? ''),
                  onChanged: (value) {
                    cubit.selectedGender = value.toString();
                  },
                ),
                const Text('أنثى'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (cubit.childId != null) {
                  cubit.submitGuardian(childId: cubit.childId!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى اختيار طفل أولاً'),
                    ),
                  );
                }
              },
              child: const Text('إرسال البيانات'),
            ),
          ],
        ),
      ),
    );
  }
}
*/