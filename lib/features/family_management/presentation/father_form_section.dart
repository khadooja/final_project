import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';

class FatherFormSection extends StatelessWidget {
  const FatherFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FatherCubit, FatherState>(
      builder: (context, state) {
        final cubit = context.read<FatherCubit>();

        return SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: cubit.firstNameController,
                        decoration:
                            const InputDecoration(labelText: 'الاسم الأول'),
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
                        decoration:
                            const InputDecoration(labelText: 'رقم الهوية'),
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
                        decoration:
                            const InputDecoration(labelText: 'رقم الهاتف'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: cubit.emailController,
                        decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني'),
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

                // الجنس
                Row(
                  children: [
                    const Text('الجنس:'),
                    Radio<String>(
                      value: '1',
                      groupValue: cubit.selectedGender,
                      onChanged: (value) {
                        cubit.setGender(value!);
                      },
                    ),
                    const Text('ذكر'),
                    Radio<String>(
                      value: '2',
                      groupValue: cubit.selectedGender,
                      onChanged: (value) {
                        cubit.setGender(value!);
                      },
                    ),
                    const Text('أنثى'),
                  ],
                ),
                const SizedBox(height: 16),

                // الجنسية
                DropdownButtonFormField<int>(
                  value: cubit.selectedNationalityId,
                  items: cubit.nationalities
                      .map(
                        (nat) => DropdownMenuItem(
                          value: nat.id,
                          child: Text(nat.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    cubit.setNationality(value);
                  },
                  decoration: const InputDecoration(labelText: 'الجنسية'),
                ),
                const SizedBox(height: 16),

                // الجنسية
                DropdownButtonFormField<int>(
                  value: cubit.selectedNationalityId,
                  items: cubit.nationalities
                      .map(
                        (nat) => DropdownMenuItem(
                          value: nat.id,
                          child: Text(nat.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    cubit.setNationality(value);
                  },
                  decoration: const InputDecoration(labelText: 'الجنسية'),
                ),
                const SizedBox(height: 16),

// المدينة
                DropdownButtonFormField<String>(
                  value: cubit.selectedCity,
                  decoration: const InputDecoration(labelText: 'المدينة'),
                  items: cubit.cities
                      .map(
                        (city) => DropdownMenuItem(
                          value: city.name,
                          child: Text(city.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      cubit.setCity(value); // تحديث المدينة في الحالة
                      cubit.loadAreasByCityId(
                          PersonType.father, value); // تحميل الأحياء
                    }
                  },
                ),
                const SizedBox(height: 16),

// الحي
                DropdownButtonFormField<int>(
                  value: cubit.selectedAreaId,
                  items: cubit.areas
                      .map(
                        (area) => DropdownMenuItem(
                          value: area.id,
                          child: Text(area.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    cubit.setArea(value);
                  },
                  decoration: const InputDecoration(labelText: 'الحي'),
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 16),

                Row(
                  children: [
                    const Text('هل الأب متوفى؟'),
                    Switch(
                      value: cubit.isDead,
                      onChanged: (value) {
                        cubit.setIsDead(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    cubit.submitFather();
                  },
                  child: const Text('إرسال البيانات'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
