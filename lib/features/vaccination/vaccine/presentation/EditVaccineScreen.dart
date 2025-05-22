import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/vaccination/vaccine/model/vaccine_model.dart';

class EditVaccineScreen extends StatefulWidget {
  final int vaccineId;

  const EditVaccineScreen({super.key, required this.vaccineId});

  @override
  State<EditVaccineScreen> createState() => _EditVaccineScreenState();
}

class _EditVaccineScreenState extends State<EditVaccineScreen> {
  final _formKey = GlobalKey<FormState>();
  late VaccineModel model;
  bool isLoading = true;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final doseCountController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadVaccineData();
  }

  Future<void> loadVaccineData() async {
    try {
      final data = await ApiServiceManual(dio: Dio())
          .getVaccineEditData(widget.vaccineId);

      if (data == null) {
        throw Exception("لم يتم العثور على بيانات التطعيم");
      }

      model = VaccineModel.fromJson(data);

      nameController.text = model.name;
      descriptionController.text = model.description ?? '';
      doseCountController.text = model.doseCount.toString();
      categoryController.text = model.category;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("خطأ"),
            content: Text("فشل في تحميل بيانات التطعيم:\n$e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("حسناً"),
              )
            ],
          ),
        );
      }
    }
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      final updatedModel = VaccineModel(
        id: model.id,
        name: nameController.text,
        description: descriptionController.text,
        doseCount: int.tryParse(doseCountController.text) ?? 0,
        category: categoryController.text,
        status: model.status,
        stages: model.stages,
        doses: model.doses,
      );

      await ApiServiceManual(dio: Dio()).updateVaccine(model.id, updatedModel);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تعديل التطعيم')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomInputField(
                controller: nameController,
                label: 'اسم التطعيم',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              CustomInputField(
                controller: descriptionController,
                label: 'الوصف',
              ),
              CustomInputField(
                controller: doseCountController,
                label: 'عدد الجرعات',
              ),
              CustomInputField(
                controller: categoryController,
                label: 'الفئة',
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: save,
                text: 'حفظ التعديلات',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
