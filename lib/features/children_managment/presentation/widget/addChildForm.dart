import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_cubit.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_state.dart';

class AddChildForm extends StatefulWidget {
  final int fatherId;
  final int motherId;

  const AddChildForm({super.key, required this.fatherId, required this.motherId});

  @override
  State<AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _birthDate = TextEditingController();
  final _vaccinationCard = TextEditingController();
  final _certificateNumber = TextEditingController();
  final _description = TextEditingController();
  final _startDate = TextEditingController();

  String _gender = "ذكر";
  String _certificateType = "داخلية";
  bool _hasSpecialCase = false;

  int? _selectedNationality;
  int? _selectedCountry;
  int? _selectedForeignBirthCountry;
  int? _selectedSpecialCase;

  @override
  void initState() {
    super.initState();
    context.read<ChildCubit>().loadInitialDropdownData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildCubit, ChildState>(
      listener: (context, state) {
        if (state is ChildSuccess) {
          Navigator.pop(context, true);
        } else if (state is ChildFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ChildLoading || state is ChildLoadingDropdowns) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChildLoadedDropdowns) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(children: [
                    Expanded(child: _buildTextField(_firstName, "الاسم الأول")),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField(_lastName, "الاسم الأخير")),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _buildDateField(_birthDate, "تاريخ الميلاد")),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField(_vaccinationCard, "رقم بطاقة التطعيم")),
                  ]),
                  const SizedBox(height: 10),
                  _buildGenderSelector(),
                  const SizedBox(height: 10),
                  _buildCertificateTypeSelector(),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _buildTextField(_certificateNumber, "رقم شهادة الميلاد")),
                    const SizedBox(width: 10),
                    Expanded(child: _buildDropdown(state.nationalities, "الجنسية", (val) => _selectedNationality = val)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _buildDropdown(state.countries, "بلد الولادة", (val) => _selectedForeignBirthCountry = val)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildDropdown(state.countries, "مكان إصدار الشهادة", (val) => _selectedCountry = val)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("هل لديه حالة خاصة؟"),
                    Radio(value: true, groupValue: _hasSpecialCase, onChanged: (val) => setState(() => _hasSpecialCase = true)),
                    const Text("نعم"),
                    Radio(value: false, groupValue: _hasSpecialCase, onChanged: (val) => setState(() => _hasSpecialCase = false)),
                    const Text("لا"),
                  ]),
                  if (_hasSpecialCase) ...[
                    const SizedBox(height: 10),
                    _buildDropdown(state.specialCases, "نوع الحالة الخاصة", (val) => _selectedSpecialCase = val),
                    const SizedBox(height: 10),
                    _buildTextField(_description, "وصف الحالة"),
                    const SizedBox(height: 10),
                    _buildDateField(_startDate, "تاريخ بداية الحالة"),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final childData = {
                          "first_name": _firstName.text,
                          "last_name": _lastName.text,
                          "birth_date": _birthDate.text,
                          "gender": _gender,
                          "has_specail_case": _hasSpecialCase ? 1 : 0,
                          "birth_certificate_number": _certificateNumber.text,
                          "birth_certificate_type": _certificateType,
                          "health_centers_id": 1,
                          "nationalities_id": _selectedNationality,
                          "fathers_id": widget.fatherId,
                          "mothers_id": widget.motherId,
                          "countries_id": _selectedCountry,
                          "foreing_birth_country_id": _selectedForeignBirthCountry,
                        };

                        if (_hasSpecialCase) {
                          childData.addAll({
                            "case_name": state.specialCases.firstWhere((e) => e.id == _selectedSpecialCase).caseName,
                            "description": _description.text,
                            "start_date": _startDate.text,
                          });
                        }

                        context.read<ChildCubit>().addChild(childData);
                      }
                    },
                    child: const Text("إضافة الطفل"),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text("تعذر تحميل البيانات"));
        }
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          controller.text = DateFormat("yyyy-MM-dd").format(picked);
        }
      },
      validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
    );
  }

  Widget _buildDropdown<T extends Object>(
    List<T> items,
    String label,
    Function(int) onChanged,
  ) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items
          .map<DropdownMenuItem<int>>((e) => DropdownMenuItem<int>(
                value: (e as dynamic).id,
                child: Text((e as dynamic).name.toString()),
              ))
          .toList(),
      onChanged: (val) => onChanged(val!),
      validator: (val) => val == null ? "مطلوب" : null,
    );
  }

  Widget _buildGenderSelector() {
    return Row(children: [
      const Text("الجنس:"),
      Radio(value: "ذكر", groupValue: _gender, onChanged: (val) => setState(() => _gender = val!)),
      const Text("ذكر"),
      Radio(value: "أنثى", groupValue: _gender, onChanged: (val) => setState(() => _gender = val!)),
      const Text("أنثى"),
    ]);
  }

  Widget _buildCertificateTypeSelector() {
    return Row(children: [
      const Text("نوع الشهادة:"),
      Radio(value: "داخلية", groupValue: _certificateType, onChanged: (val) => setState(() => _certificateType = val!)),
      const Text("داخلية"),
      Radio(value: "خارجية", groupValue: _certificateType, onChanged: (val) => setState(() => _certificateType = val!)),
      const Text("خارجية"),
    ]);
  }
}
