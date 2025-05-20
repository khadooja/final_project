import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/vaccination/dose/logic/cubit/dose_cubit.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchVaccines();
  }

  void _fetchVaccines() async {
    // مؤقتًا فقط - لاحقًا يتم جلبها من API
    setState(() {
      _vaccineItems = [
        DropdownMenuItem(value: '1', child: Text('تطعيم الحصبة')),
        DropdownMenuItem(value: '2', child: Text('تطعيم شلل الأطفال')),
      ];
    });
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
    return BlocConsumer<DoseCubit, DoseState>(
      listener: (context, state) {
        if (state is DoseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة الجرعة بنجاح')),
          );
          Navigator.pop(context); // يرجع للخلف بعد النجاح
        } else if (state is DoseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل في الإضافة: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _doseNumberController,
                decoration: const InputDecoration(labelText: 'رقم الجرعة'),
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _ageYearsController,
                decoration: const InputDecoration(labelText: 'العمر (سنوات)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _ageMonthsController,
                decoration: const InputDecoration(labelText: 'العمر (أشهر)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _ageDaysController,
                decoration: const InputDecoration(labelText: 'العمر (أيام)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _delayDaysController,
                decoration:
                    const InputDecoration(labelText: 'مدة التأخير (أيام)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedVaccineId,
                items: _vaccineItems,
                decoration: const InputDecoration(labelText: 'اسم التطعيم'),
                onChanged: (val) => setState(() => _selectedVaccineId = val),
                validator: (val) => val == null ? 'مطلوب' : null,
              ),
              const SizedBox(height: 24),
              state is DoseLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('إضافة الجرعة'),
                    ),
            ],
          ),
        );
      },
    );
  }
}
