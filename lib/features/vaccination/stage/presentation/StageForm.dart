import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/features/vaccination/stage/logic/cubit/StageCubit.dart';

class StageForm extends StatefulWidget {
  const StageForm({super.key});

  @override
  State<StageForm> createState() => _StageFormState();
}

class _StageFormState extends State<StageForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startAgeController = TextEditingController();
  final TextEditingController _endAgeController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final startAge = int.tryParse(_startAgeController.text) ?? 0;
      final endAge = int.tryParse(_endAgeController.text) ?? 0;

      if (startAge > endAge) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('يجب أن يكون عمر البداية أصغر من أو يساوي عمر النهاية'),
          ),
        );
        return; // نوقف هنا وما نرسل الطلب
      }

      final data = {
        'stage_name': _nameController.text,
        'description': _descriptionController.text,
        'stage_start_age_months': startAge,
        'stage_end_age_months': endAge,
      };

      context.read<Stagecubit>().createStage(data);
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
          const TopBar(title: "إضافة مرحلة"),
          Expanded(
            child: BlocConsumer<Stagecubit, StageState>(
              listener: (context, state) {
                if (state is StageSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت إضافة المرحلة بنجاح')),
                  );
                  Navigator.pop(context);
                } else if (state is StageError) {
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

                        // الصف الأول: اسم المرحلة + الوصف
                        CustomInputField(
                          controller: _nameController,
                          label: 'اسم المرحلة',
                          validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _descriptionController,
                          label: 'الوصف (اختياري)',
                          // maxLines: 2,
                        ),

                        const SizedBox(height: 16),

                        // الصف الثاني: العمر من - العمر إلى
                        Row(
                          children: [
                            Expanded(
                              child: CustomInputField(
                                controller: _startAgeController,
                                label: 'العمر من (أشهر)',
                                validator: (val) =>
                                    val!.isEmpty ? 'مطلوب' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomInputField(
                                controller: _endAgeController,
                                label: 'العمر إلى (أشهر)',
                                validator: (val) =>
                                    val!.isEmpty ? 'مطلوب' : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // زر الإضافة
                        state is StageLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                onPressed: _submitForm,
                                text: 'إضافة المرحلة',
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
