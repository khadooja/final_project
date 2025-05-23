import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

class FatherFormSection extends StatefulWidget {
  final SearchPersonResponse? searchResult;
  const FatherFormSection({super.key, this.searchResult});

  @override
  State<FatherFormSection> createState() => _FatherFormSectionState();
}

class _FatherFormSectionState extends State<FatherFormSection> {
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fillFromSearchResult(firstLoad: true);
      context.read<FatherCubit>().loadDropdowns(); // ⬅️ تحميل المدن والجنسيات
  _fillFromSearchResult(firstLoad: true);

  }

  @override
  void didUpdateWidget(covariant FatherFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchResult != oldWidget.searchResult) {
      _fillFromSearchResult();
    }
  }

    void _fillFromSearchResult({bool firstLoad = false}) {
  final cubit = context.read<FatherCubit>();
  final result = widget.searchResult;

  print("=== searchResult: $result ===");

  if (result?.data != null) {
    _initialDataLoaded = true;
    if (result!.data!.father != null) {
      print("Father data found");
      cubit.fillFormFromFather(result);
    } else if (result.data!.person != null) {
      print("Person data found");
      cubit.fillFormFromPerson(result);
    }
    print("Father data: ${result.data!.father}");
    print("Person data: ${result.data!.person}");
    _initialDataLoaded = true;
  } else {
    print("Data is null, clearing form");
    cubit.clearForm();
  }
}

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FatherCubit>();
    return BlocConsumer<FatherCubit, FatherState>(
      listener: (context, state) {
        if (state is FatherLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('جاري التحميل...')),
          );
        } else if (state is FatherSuccess) {
          context.read<FatherCubit>().loadDropdowns();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
          );
        } else if (state is FatherError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        controller: cubit.firstNameController,
                        label: 'الاسم الأول',
                        keyboardType: InputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء إدخال الاسم الأول'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomInputField(
                        controller: cubit.lastNameController,
                        label: 'الاسم الأخير',
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء إدخال الاسم الأخير'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<int>(
                        value: cubit.selectedNationalityId,
                        decoration: const InputDecoration(
                          labelText: 'الجنسية',
                          border: OutlineInputBorder(),
                        ),
                        items: cubit.nationalities
                            .map((nat) => DropdownMenuItem(
                                  value: nat.id,
                                  child: Text(nat.nationality_name),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            cubit.selectedNationalityId = value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('هل الأب متوفى؟'),
                          Switch(
                            value: cubit.isDead,
                            onChanged: cubit.setIsDead,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (!cubit.isDead) ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          controller: cubit.emailController,
                          label: 'البريد الإلكتروني',
                          keyboardType: InputType.email,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomInputField(
                          controller: cubit.birthDateController,
                          label: 'تاريخ الميلاد',
                          keyboardType: InputType.date,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          label: 'المدينة',
                          keyboardType: InputType.dropdown,
                          selectedValue: cubit.selectedCity,
                          dropdownItems:
                              cubit.cities.map((e) => e.city_name).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              cubit.setCity(value);
                              cubit.loadAreasByCityId(PersonType.father, value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: cubit.selectedAreaId,
                          decoration: const InputDecoration(
                            labelText: 'الحي',
                            border: OutlineInputBorder(),
                          ),
                          items: cubit.areas
                              .map((area) => DropdownMenuItem(
                                    value: area.id,
                                    child: Text(area.area_name),
                                  ))
                              .toList(),
                          onChanged: cubit.setArea,
                          validator: (val) =>
                              val == null ? 'يرجى اختيار الحي' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          controller: cubit.phoneController,
                          label: 'رقم الهاتف',
                          keyboardType: InputType.phone,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomInputField(
                          controller: cubit.identityController,
                          label: 'رقم الهوية',
                          keyboardType: InputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          label: 'الجنس',
                          keyboardType: InputType.radio,
                          radioOptions: const ['ذكر', 'أنثى'],
                          selectedValue: cubit.selectedGender,
                          onChanged: (val) => cubit.setGender(val!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomInputField(
                          label: 'الحالة',
                          keyboardType: InputType.radio,
                          radioOptions: const ['غير نشط', 'نشط'],
                          selectedValue: cubit.is_Active.toString(),
                          onChanged: (val) => cubit.setIsActive(val! == 'نشط'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'عدد الأطفال',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => cubit.childCount = int.tryParse(v) ?? 0,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'حفظ البيانات',
                      onPressed: cubit.submitFather,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
