import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/features/vaccination/dose/model/dose_model.dart';
import 'package:new_project/features/vaccination/stage/model/StageModel.dart';
import 'package:new_project/features/vaccination/vaccine/logic/vaccine_cubit.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';

class AddVaccineScreen extends StatefulWidget {
  @override
  _AddVaccineScreenState createState() => _AddVaccineScreenState();
}

class _AddVaccineScreenState extends State<AddVaccineScreen> {
  final TextEditingController vaccineNameController = TextEditingController();
  final TextEditingController vaccineDescriptionController =
      TextEditingController();
  String selectedCategory = 'جائحة';
  int selectedDoseCount = 1;
  List<StageModel> stages = [];
  List<Map<String, dynamic>> doseFields = [];

  final List<String> categories = ['جائحة', 'سفر', 'أطفال'];

  @override
  void initState() {
    super.initState();
    generateDoseFields(1);
    context.read<VaccineCubit>().getStages(); // جلب المراحل
  }

  void generateDoseFields(int count) {
    doseFields = List.generate(count, (index) {
      return {
        'nameController': TextEditingController(),
        'ageController': TextEditingController(),
        'delayController': TextEditingController(),
        'selectedStage': 1,
      };
    });
    setState(() {});
  }

  Map<String, int> convertMonthsToYearsAndDays(int months) {
    int years = months ~/ 12;
    int remainingMonths = months % 12;
    int days = remainingMonths * 30;
    return {'years': years, 'days': days};
  }

  void submitVaccineData() {
    List<DoseModel> doses = [];

    for (var field in doseFields) {
      int months = int.tryParse(field['ageController'].text) ?? 0;
      var converted = convertMonthsToYearsAndDays(months);

      doses.add(DoseModel(
        doseNumber: field['nameController'].text,
        ageYears: converted['years']!,
        ageMonths: months % 12,
        ageDays: converted['days']!,
        delayDays: int.tryParse(field['delayController'].text) ?? 0,
      ));
    }

    List<int> selectedStages =
        doseFields.map((f) => f['selectedStage'] as int).toList();

    List<StageModel> stagesList = selectedStages
        .map((id) => StageModel(
              id: id,
              stageName: '',
              description: '',
              stageStartAgeMonths: 0,
              stageEndAgeMonths: 0,
            ))
        .toList();

    VaccineModel vaccine = VaccineModel(
      id: 0,
      name: vaccineNameController.text,
      description: vaccineDescriptionController.text,
      category: selectedCategory,
      doseCount: selectedDoseCount,
      status: 'active',
      stages: stagesList,
      doses: doses,
    );

    context.read<VaccineCubit>().addVaccine(vaccine);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VaccineCubit, VaccineState>(
      listener: (context, state) {
        if (state is VaccineError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is VaccineAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة التطعيم بنجاح')));
          Navigator.pop(context, true);
        } else if (state is VaccineStagesLoaded) {
          setState(() {
            stages = state.stages;
            for (var field in doseFields) {
              if (!stages.any((s) => s.id == field['selectedStage'])) {
                field['selectedStage'] =
                    stages.isNotEmpty ? stages.first.id : 1;
              }
            }
          });
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          // استخدمت TopBar بدل AppBar
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: TopBar(title: 'إضافة تطعيم'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('إضافة تطعيم جديد',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),

                // استخدمنا CustomInputField بدل TextField
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        controller: vaccineNameController,
                        label: 'اسم التطعيم',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomInputField(
                        controller: vaccineDescriptionController,
                        label: 'وصف التطعيم',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'التصنيف'),
                        value: selectedCategory,
                        items: categories
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedCategory = val!),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: 'عدد الجرعات'),
                        value: selectedDoseCount,
                        items: List.generate(10, (i) => i + 1)
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text('$c')))
                            .toList(),
                        onChanged: (val) {
                          selectedDoseCount = val!;
                          generateDoseFields(val);
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Text('بيانات الجرعات',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),

                stages.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: doseFields.asMap().entries.map((entry) {
                          int index = entry.key;
                          var field = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('الجرعة ${index + 1}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomInputField(
                                      controller: field['nameController'],
                                      label: 'اسم الجرعة',
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      decoration:
                                          InputDecoration(labelText: 'المرحلة'),
                                      value: field['selectedStage'],
                                      items: stages
                                          .map((s) => DropdownMenuItem(
                                                value: s.id,
                                                child: Text(s.stageName),
                                              ))
                                          .toList(),
                                      onChanged: (val) => setState(
                                          () => field['selectedStage'] = val!),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // عمر موصى به ك Dropdown مع تحديث قيمة ageController.text
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    labelText: 'اسم التطعيم'),
                                value: field['ageController'].text.isEmpty
                                    ? '1'
                                    : field['ageController'].text,
                                items: List.generate(
                                        120, (i) => (i + 1).toString())
                                    .map((month) => DropdownMenuItem(
                                          value: month,
                                          child: Text(
                                            '$month شهر',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    68, 68, 65, 1)),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    field['ageController'].text = val!;
                                  });
                                },
                              ),
                              SizedBox(height: 8),

                              CustomInputField(
                                controller: field['delayController'],
                                label: 'أيام التأخير',
                                // keyboardType: TextInputType.number,
                              ),

                              Divider(thickness: 1.2),
                            ],
                          );
                        }).toList(),
                      ),

                SizedBox(height: 20),

                // زر مخصص
                CustomButton(
                  onPressed: submitVaccineData,
                  text: 'إضافة التطعيم',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
