import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';

class GuardianForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController identityNumberController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController childCountController;
  final TextEditingController endDateController;

  final String? selectedGender;
  final Function(String?) onGenderChanged;

  final int? selectedNationalityId;
  final List<String> nationalities;
  final Function(String?) onNationalityChanged;

  final int? selectedLocationId;
  final List<String> locations;
  final Function(String?) onLocationChanged;

  final bool isDeceased;
  final bool isActive;

  final Function(bool?) onIsDeceasedChanged;
  final Function(bool?) onIsActiveChanged;

  final bool enabled;

  const GuardianForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.identityNumberController,
    required this.phoneNumberController,
    required this.emailController,
    required this.addressController,
    required this.childCountController,
    required this.endDateController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.selectedNationalityId,
    required this.nationalities,
    required this.onNationalityChanged,
    required this.selectedLocationId,
    required this.locations,
    required this.onLocationChanged,
    required this.isDeceased,
    required this.isActive,
    required this.onIsDeceasedChanged,
    required this.onIsActiveChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: CustomInputField(
              label: 'الاسم الأول',
              controller: firstNameController,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomInputField(
              label: 'الاسم الأخير',
              controller: lastNameController,
            ),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: CustomInputField(
              label: 'رقم الهوية',
              controller: identityNumberController,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomInputField(
              label: 'رقم الجوال',
              controller: phoneNumberController,
            ),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: CustomInputField(
              label: 'البريد الإلكتروني',
              controller: emailController,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomInputField(
              label: 'عدد الأطفال',
              controller: childCountController,
              keyboardType: InputType.text,
            ),
          ),
        ]),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'تاريخ الانتهاء',
          controller: endDateController,
          keyboardType: InputType.date,
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: CustomInputField(
              label: 'الجنس',
              keyboardType: InputType.dropdown,
              dropdownItems: const ['ذكر', 'أنثى'],
              selectedValue: selectedGender,
              onChanged: onGenderChanged,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomInputField(
              label: 'الجنسية',
              keyboardType: InputType.dropdown,
              dropdownItems: nationalities,
              selectedValue: selectedNationalityId != null
                  ? nationalities[selectedNationalityId! - 1]
                  : null,
              onChanged: onNationalityChanged,
            ),
          ),
        ]),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'المدينة',
          keyboardType: InputType.dropdown,
          dropdownItems: locations,
          selectedValue: selectedLocationId != null
              ? locations[selectedLocationId! - 1]
              : null,
          onChanged: onLocationChanged,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'العنوان',
          controller: addressController,
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: CheckboxListTile(
              title: const Text('متوفى؟'),
              value: isDeceased,
              onChanged: enabled ? onIsDeceasedChanged : null,
            ),
          ),
          Expanded(
            child: CheckboxListTile(
              title: const Text('نشط؟'),
              value: isActive,
              onChanged: enabled ? onIsActiveChanged : null,
            ),
          ),
        ]),
      ],
    );
  }
}
