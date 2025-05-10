/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/features/childSpecialCase/data/model/special_case.dart';
import 'package:new_project/features/children_managment/data/model/country_model.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_cubit.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_state.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';

class AddChildForm extends StatefulWidget {
  const AddChildForm({super.key});

  @override
  State<AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController vaccineCardController = TextEditingController();
  final TextEditingController certificateNumberController = TextEditingController();
  final TextEditingController specialCaseDescriptionController = TextEditingController();
  final TextEditingController specialCaseStartDateController = TextEditingController();
  final TextEditingController otherCaseController = TextEditingController();

  // Dropdown values
  int? selectedNationalityId;
  int? selectedCountryId;
  int? selectedSpecialCaseId;

  // Radios
  String gender = 'ذكر';
  String birthCertificateType = 'داخلية';
  bool hasSpecialCase = false;
  bool hasGuardian = false;

  Map<String, dynamic>? selectedFather;
Map<String, dynamic>? selectedMother;
Map<String, dynamic>? selectedGuardian;




  @override
  void initState() {
    super.initState();
    context.read<ChildCubit>().loadInitialDropdownData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildCubit, ChildState>(
      builder: (context, state) {
        if (state is ChildLoadingDropdowns) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChildFailure) {
          return Center(child: Text(state.message));
        }

        if (state is ChildLoadedDropdowns) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                _buildRow([
                  CustomInputField(
                    label: 'الاسم الأول',
                    controller: firstNameController,
                    keyboardType: InputType.text,                   
                  ),
                  CustomInputField(
                    label: 'الاسم الأخير',
                    controller: lastNameController,
                    keyboardType: InputType.text,
                  ),
                ]),
                _buildRow([
                  CustomInputField(
                    label: 'تاريخ الميلاد',
                    controller: birthDateController,
                    keyboardType: InputType.date,
                  ),
                  CustomInputField(
                    label: 'رقم بطاقة التطعيم',
                    controller: vaccineCardController,
                    keyboardType: InputType.text,
                  ),
                ]),
                _buildRow([
                  _buildGenderRadios(),
                  _buildBirthCertificateRadios(),
                ]),
                _buildRow([
                  CustomInputField(
                    label: 'رقم شهادة الميلاد',
                    controller: certificateNumberController,
                    keyboardType: InputType.text,

                  ),
                  _buildNationalityDropdown(state.nationalities),
                ]),
                _buildRow([
                  _buildCountryDropdown(state.countries),
                  _buildYesNoRadio(
                    label: 'هل لديه حالة خاصة؟',
                    value: hasSpecialCase,
                    onChanged: (val) {
                      setState(() {
                        hasSpecialCase = val;
                      });
                    },
                  ),
                ]),

                if (hasSpecialCase) ...[
                  _buildRow([
                    _buildSpecialCaseDropdown(state.specialCases),
                    CustomInputField(
                      label: 'وصف الحالة',
                      controller: specialCaseDescriptionController,
                      keyboardType: InputType.text,
                    ),
                  ]),
                  _buildRow([
                    CustomInputField(
                      label: 'غير ذلك',
                      controller: otherCaseController,
                      keyboardType: InputType.text,
                    ),
                    CustomInputField(
                      label: 'تاريخ بدء الحالة',
                      controller: specialCaseStartDateController,
                      keyboardType: InputType.date,
                    ),
                  ]),
                ],

                _buildSectionTitle("اختيار الأب والأم"),

Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.search),
        label: Text(selectedFather != null ? selectedFather!['fullName'] : "اختر الأب"),
        onPressed: () async {
          final result = await _showSearchDialog(context, title: "بحث عن الأب");
          if (result != null) {
            setState(() {
              selectedFather = result;
            });
          }
        },
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.search),
        label: Text(selectedMother != null ? selectedMother!['fullName'] : "اختر الأم"),
        onPressed: () async {
          final result = await _showSearchDialog(context, title: "بحث عن الأم");
          if (result != null) {
            setState(() {
              selectedMother = result;
            });
          }
        },
      ),
    ),
  ],
),


     _buildYesNoRadio(
  label: 'هل لديه كفيل؟',
  value: hasGuardian,
  onChanged: (val) {
    setState(() {
      hasGuardian = val;
    });
  },
),

if (hasGuardian) ...[
  const SizedBox(height: 12),
  ElevatedButton.icon(
    icon: const Icon(Icons.arrow_forward),
    label: const Text("الانتقال لاختيار الكفيل"),
    onPressed: () {
      // بعد التأكد من صحة النموذج وإضافة الطفل
      if (_formKey.currentState!.validate()) {
        final childData = {
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'birthDate': birthDateController.text,
          'gender': gender,
          'birthCertificateType': birthCertificateType,
          'certificateNumber': certificateNumberController.text,
          'vaccineCardNumber': vaccineCardController.text,
          'nationalityId': selectedNationalityId,
          'birthCertificateCountryId': selectedCountryId,
          'hasSpecialCase': hasSpecialCase,
          'specialCaseId': selectedSpecialCaseId,
          'specialCaseDescription': specialCaseDescriptionController.text,
          'specialCaseStartDate': specialCaseStartDateController.text,
          'otherCase': otherCaseController.text,
          'fatherId': selectedFather?['id'],
          'motherId': selectedMother?['id'],
        };

        // إرسال بيانات الطفل للسيرفر
        context.read<ChildCubit>().submitChild(childData).then((childId) {
          if (childId != null && childId > 0) {
            Navigator.pushNamed(
              context,
              '/add-child-guardian',
              arguments: childId,
            );
          }
        });
      }
    },
  ),
],

ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      final childData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'birthDate': birthDateController.text,
        'gender': gender,
        'birthCertificateType': birthCertificateType,
        'certificateNumber': certificateNumberController.text,
        'vaccineCardNumber': vaccineCardController.text,
        'nationalityId': selectedNationalityId,
        'birthCertificateCountryId': selectedCountryId,
        'hasSpecialCase': hasSpecialCase,
        'specialCaseId': selectedSpecialCaseId,
        'specialCaseDescription': specialCaseDescriptionController.text,
        'specialCaseStartDate': specialCaseStartDateController.text,
        'otherCase': otherCaseController.text,
        'fatherId': selectedFather?['id'],
        'motherId': selectedMother?['id'],
        'guardianId': hasGuardian ? selectedGuardian != null?['id']
      };

      print("بيانات الطفل: $childData");
      // TODO: استدعاء Cubit لإرسال البيانات إلى السيرفر
    }
  },
  child: const Text('إضافة الطفل'),
),


               
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
Future<String?> _showSearchDialog(BuildContext context, {required String title}) async {
  TextEditingController idController = TextEditingController();

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: idController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "رقم الهوية"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              final id = idController.text.trim();
              if (id.isNotEmpty) {
                Navigator.pop(context, id); // فقط ترجع رقم الهوية
              }
            },
            child: const Text("بحث"),
          ),
        ],
      );
    },
  );
}

  Widget _buildRow(List<Widget> children) {
    return Row(
      children: children
          .map((child) => Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              )))
          .toList(),
    );
  }

  Widget _buildGenderRadios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("الجنس"),
        RadioListTile<String>(
          title: const Text("ذكر"),
          value: 'ذكر',
          groupValue: gender,
          onChanged: (val) => setState(() => gender = val!),
        ),
        RadioListTile<String>(
          title: const Text("أنثى"),
          value: 'أنثى',
          groupValue: gender,
          onChanged: (val) => setState(() => gender = val!),
        ),
      ],
    );
  }

  Widget _buildBirthCertificateRadios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("نوع شهادة الميلاد"),
        RadioListTile<String>(
          title: const Text("داخلية"),
          value: 'داخلية',
          groupValue: birthCertificateType,
          onChanged: (val) => setState(() => birthCertificateType = val!),
        ),
        RadioListTile<String>(
          title: const Text("خارجية"),
          value: 'خارجية',
          groupValue: birthCertificateType,
          onChanged: (val) => setState(() => birthCertificateType = val!),
        ),
      ],
    );
  }

  Widget _buildYesNoRadio({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        RadioListTile<bool>(
          title: const Text("نعم"),
          value: true,
          groupValue: value,
          onChanged: (val) => onChanged(val!),
        ),
        RadioListTile<bool>(
          title: const Text("لا"),
          value: false,
          groupValue: value,
          onChanged: (val) => onChanged(val!),
        ),
      ],
    );
  }

  Widget _buildNationalityDropdown(List<NationalityModel> items) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: "الجنسية"),
      value: selectedNationalityId,
      items: items
          .map((e) => DropdownMenuItem<int>(
                value: e.id,
                child: Text(e.name),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          selectedNationalityId = val;
        });
      },
    );
  }

  Widget _buildCountryDropdown(List<CountryModel> items) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: "مكان إصدار الشهادة"),
      value: selectedCountryId,
      items: items
          .map((e) => DropdownMenuItem<int>(
                child: Text(e.name),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          selectedCountryId = val;
        });
      },
    );
  }

  Widget _buildSpecialCaseDropdown(List<SpecialCase> items) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: "نوع الحالة الخاصة"),
      value: selectedSpecialCaseId,
      items: items
          .map((e) => DropdownMenuItem<int>(
                value: e.id,
                child: Text(e.caseName),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          selectedSpecialCaseId = val;
        });
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}*/
