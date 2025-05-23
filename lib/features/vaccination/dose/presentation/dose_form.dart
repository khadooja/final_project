import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/vaccination/dose/logic/cubit/dose_cubit.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';

class DoseForm extends StatefulWidget {
  const DoseForm({super.key});

  @override
  State<DoseForm> createState() => _DoseFormState();
}

class _DoseFormState extends State<DoseForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _doseNumberController = TextEditingController();
  final TextEditingController _ageYearsController = TextEditingController();
  final TextEditingController _ageMonthsController = TextEditingController();
  final TextEditingController _ageDaysController = TextEditingController();
  final TextEditingController _delayDaysController = TextEditingController();

  String? _selectedVaccineId;
  List<DropdownMenuItem<String>> _vaccineItems = [];
  bool _isLoadingVaccines = true;

  @override
  void initState() {
    super.initState();
    _fetchVaccines();
  }

  void _fetchVaccines() async {
    try {
      final vaccines = await ApiServiceManual(dio: Dio()).getVaccines();
      setState(() {
        _vaccineItems = vaccines
            .map((vaccine) => DropdownMenuItem<String>(
                  value: vaccine.id.toString(),
                  child: Text(vaccine.name),
                ))
            .toList();
        _isLoadingVaccines = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingVaccines = false;
      });
      debugPrint("فشل في تحميل التطعيمات: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل قائمة التطعيمات')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedVaccineId != null) {
      final data = {
        'dose_number': _doseNumberController.text,
        'age_years': int.parse(_ageYearsController.text),
        'age_months': int.parse(_ageMonthsController.text),
        'age_days': int.parse(_ageDaysController.text),
        'delay_days': int.parse(_delayDaysController.text),
        'vaccine_id': _selectedVaccineId,
      };

      context.read<DoseCubit>().createDose(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const TopBar(title: "إضافة جرعة"),
          Expanded(
            child: BlocConsumer<DoseCubit, DoseState>(
              listener: (context, state) {
                if (state is DoseSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت إضافة الجرعة بنجاح')),
                  );
                  Navigator.pop(context);
                } else if (state is DoseError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('فشل في الإضافة: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          const SizedBox(height: 16),

                          // الصف الأول: العمر (سنوات - أشهر - أيام)
                          Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  controller: _ageYearsController,
                                  label: 'العمر (سنوات)',
                                  //keyboardType: TextInputType.number,
                                  validator: (val) =>
                                      val!.isEmpty ? 'مطلوب' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomInputField(
                                  controller: _ageMonthsController,
                                  label: 'العمر (أشهر)',
                                  // keyboardType: TextInputType.number,
                                  validator: (val) =>
                                      val!.isEmpty ? 'مطلوب' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomInputField(
                                  controller: _ageDaysController,
                                  label: 'العمر (أيام)',
                                  //keyboardType: TextInputType.number,
                                  validator: (val) =>
                                      val!.isEmpty ? 'مطلوب' : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // الصف الثاني: رقم الجرعة - مدة التأخير
                          Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  controller: _doseNumberController,
                                  label: 'رقم الجرعة',
                                  validator: (val) =>
                                      val!.isEmpty ? 'مطلوب' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomInputField(
                                  controller: _delayDaysController,
                                  label: 'مدة التأخير (أيام)',
                                  //keyboardType: TextInputType.number,
                                  validator: (val) =>
                                      val!.isEmpty ? 'مطلوب' : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Dropdown: اسم التطعيم
                          _isLoadingVaccines
                              ? const Center(child: CircularProgressIndicator())
                              : DropdownButtonFormField<String>(
                                  value: _selectedVaccineId,
                                  items: _vaccineItems,
                                  decoration: const InputDecoration(
                                      labelText: 'اسم التطعيم'),
                                  onChanged: (val) =>
                                      setState(() => _selectedVaccineId = val),
                                  validator: (val) =>
                                      val == null ? 'مطلوب' : null,
                                ),

                          const SizedBox(height: 24),

                          // زر الإضافة
                          state is DoseLoading
                              ? const Center(child: CircularProgressIndicator())
                              : CustomButton(
                                  onPressed: _submitForm,
                                  text: 'إضافة الجرعة',
                                ),
                        ],
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
