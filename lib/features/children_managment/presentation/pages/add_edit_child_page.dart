// features/children_managment/presentation/pages/add_edit_child_page.dart
/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/theme/colors.dart';
// Import the new detailed models
import 'package:new_project/features/children_managment/data/model/child_detail_model.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_cubit.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_state.dart';
// You might not need DisplayedChildModel here anymore if always fetching details
// import 'package:new_project/features/children_managment/data/model/displayed_child_model.dart';

class AddEditChildPage extends StatefulWidget {
  final String? childIdToEdit; // Primarily use this (String ID)
  // childToEdit is less likely to be used if we always fetch fresh details
  // final DisplayedChildModel? childToEdit;

  const AddEditChildPage({super.key, this.childIdToEdit});

  @override
  State<AddEditChildPage> createState() => _AddEditChildPageState();
}

class _AddEditChildPageState extends State<AddEditChildPage> {
  final _formKey = GlobalKey<FormState>();

  bool get _isEditMode => widget.childIdToEdit != null;
  ChildDetailModel? _currentChildDetail; // To store fetched detailed data

  // Form field controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _vaccineCardNumberController;
  late TextEditingController _birthCertificateNumberController;
  late TextEditingController
      _specialCaseDescriptionController; // Added for example

  // State for Radio buttons and Dropdowns
  String? _selectedGender;
  String? _selectedCertificateType;
  bool _hasSpecialCase = false;
  DateTime? _selectedBirthDate;
  DateTime? _selectedSpecialCaseStartDate;

  // Dropdown options and selected values
  List<NationalityOptionModel> _nationalityOptions = [];
  NationalityOptionModel? _selectedNationality;

  List<CountryOptionModel> _countryOptions = [];
  CountryOptionModel? _selectedBirthIssuanceCountry;

  List<SpecialCaseOptionModel> _specialCaseTypeOptions = [];
  SpecialCaseOptionModel? _selectedSpecialCaseType;

  bool _isLoadingDetails = false;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // For API
  final DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy'); // For UI

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _vaccineCardNumberController = TextEditingController();
    _birthCertificateNumberController = TextEditingController();
    _specialCaseDescriptionController = TextEditingController();

    if (widget.childIdToEdit != null) {
      _isLoadingDetails = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ChildCubit>().fetchChildDetails(widget.childIdToEdit!);
        }
      });
    } else {
      // For new child, you might want to load default dropdown options from a different source/cubit
      // For simplicity, we'll assume they'd be empty or pre-filled if adding,
      // but for edit, they come from child details.
      // _loadInitialDropdownData(); // A method to fetch general dropdown options if needed for "Add New"
    }
  }

  void _populateFormFields(ChildDetailModel childDetail) {
    _currentChildDetail = childDetail;

    _firstNameController.text = childDetail.firstName;
    _lastNameController.text = childDetail.lastName;
    _vaccineCardNumberController.text = childDetail.vaccineCardNumber;
    _birthCertificateNumberController.text = childDetail.birthCertificateNumber;

    _selectedGender = childDetail.gender;
    _selectedCertificateType = childDetail.birthCertificateType;
    _hasSpecialCase = childDetail.hasSpecialCase == 1;

    // Populate dropdown options
    _nationalityOptions = childDetail.nationalityOptions;
    _countryOptions = childDetail.countryOptions;
    _specialCaseTypeOptions = childDetail.specialCaseTypeOptions;

    // Set selected dropdown values
    // Find the matching NationalityOptionModel from the options list
    try {
      _selectedNationality = _nationalityOptions.firstWhere(
        (opt) => opt.nationalityName == childDetail.currentNationalityName,
        // orElse: () => null, // if not found, selectedNationality remains null
      );
    } catch (e) {
      _selectedNationality = null;
      print(
          "Error finding nationality: ${childDetail.currentNationalityName} in options. $e");
    }

    if (_selectedCertificateType == 'خارجية') {
      try {
        _selectedBirthIssuanceCountry = _countryOptions.firstWhere(
          (opt) => opt.countryName == childDetail.currentCountryName,
          // orElse: () => null,
        );
      } catch (e) {
        _selectedBirthIssuanceCountry = null;
        print(
            "Error finding birth country: ${childDetail.currentCountryName} in options. $e");
      }
    } else {
      _selectedBirthIssuanceCountry = null;
    }

    if (_hasSpecialCase && childDetail.currentSpecialCaseDetails.isNotEmpty) {
      final currentCaseName =
          childDetail.currentSpecialCaseDetails.first.caseName;
      try {
        _selectedSpecialCaseType = _specialCaseTypeOptions.firstWhere(
          (opt) => opt.specialCaseName == currentCaseName,
          // orElse: () => null,
        );
      } catch (e) {
        _selectedSpecialCaseType = null;
        print(
            "Error finding special case type: $currentCaseName in options. $e");
      }
      _specialCaseDescriptionController.text =
          childDetail.currentSpecialCaseDetails.first.description ?? '';
    } else {
      _selectedSpecialCaseType = null;
      _specialCaseDescriptionController.clear();
    }

    // Parse dates
    if (childDetail.birthDate != null && childDetail.birthDate!.isNotEmpty) {
      try {
        _selectedBirthDate = _dateFormat.parse(childDetail.birthDate!);
      } catch (e) {
        print("Error parsing birthDate '${childDetail.birthDate}': $e");
        _selectedBirthDate = null;
      }
    }

    if (_hasSpecialCase &&
        childDetail.currentSpecialCaseStartDates.isNotEmpty &&
        childDetail.currentSpecialCaseStartDates.first.isNotEmpty) {
      try {
        _selectedSpecialCaseStartDate =
            _dateFormat.parse(childDetail.currentSpecialCaseStartDates.first);
      } catch (e) {
        print(
            "Error parsing specialCaseStartDate '${childDetail.currentSpecialCaseStartDates.first}': $e");
        _selectedSpecialCaseStartDate = null;
      }
    }

    setState(() {
      _isLoadingDetails = false;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vaccineCardNumberController.dispose();
    _birthCertificateNumberController.dispose();
    _specialCaseDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDateSelected,
      {DateTime? initialDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // Or DateTime(2101) if future dates allowed
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textColor2,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Gather data for saving
      // Example:
      // final Map<String, dynamic> dataToSave = {
      //   'child_id': _isEditMode ? _currentChildDetail!.childId : null,
      //   'first_name': _firstNameController.text,
      //   'last_name': _lastNameController.text,
      //   'birth_date': _selectedBirthDate != null ? _dateFormat.format(_selectedBirthDate!) : null,
      //   'vaccine_card_number': _vaccineCardNumberController.text,
      //   'gender': _selectedGender,
      //   'birth_certificate_type': _selectedCertificateType,
      //   'birth_certificate_number': _birthCertificateNumberController.text,
      //   'nationality_id': _selectedNationality?.nationalityId, // Send ID
      //   'country_id': _selectedCertificateType == 'خارجية' ? _selectedBirthIssuanceCountry?.countryId : null, // Send ID
      //   'has_special_case': _hasSpecialCase ? 1 : 0,
      //   'special_case_id': _hasSpecialCase ? _selectedSpecialCaseType?.specialCaseId : null, // Send ID
      //   'special_case_description': _hasSpecialCase ? _specialCaseDescriptionController.text : null,
      //   'special_case_start_date': _hasSpecialCase && _selectedSpecialCaseStartDate != null
      //       ? _dateFormat.format(_selectedSpecialCaseStartDate!)
      //       : null,
      //   // ... father_id, mother_id if you have them
      // };
      // print("Data to save: $dataToSave");
      // context.read<ChildCubit>().saveChild(dataToSave, _isEditMode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _isEditMode ? 'جاري حفظ التعديلات...' : 'جاري إضافة الطفل...')),
      );
      // For now, just pop. Implement save logic in Cubit.
      Navigator.pop(context, true); // Pop with true to trigger list refresh
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? hint,
      bool isDate = false,
      Function()? onDateTap,
      bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor2)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          readOnly: isDate,
          onTap: isDate ? onDateTap : null,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint ?? 'ادخل $label',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: enabled ? AppColors.textBox : Colors.grey[200],
            suffixIcon: isDate
                ? const Icon(Icons.calendar_today_outlined,
                    color: AppColors.textColor1, size: 20)
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (value) {
            // Allow date fields to be optional unless explicitly required
            if (!isDate && (value == null || value.isEmpty)) {
              return 'الرجاء إدخال $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRadioGroup<T>(String label, T? groupValue, List<T> options,
      List<String> optionLabels, Function(T?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(options.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<T>(
                  value: options[index],
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: AppColors.primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(optionLabels[index],
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textColor2)),
                if (index < options.length - 1) const SizedBox(width: 10),
              ],
            );
          }).reversed.toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemText, // How to display item in dropdown
    required Function(T?) onChanged,
    String? hint,
    String? validationMessage,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor2)),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(itemText(item), textAlign: TextAlign.right),
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint ?? 'اختر $label',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: enabled ? AppColors.textBox : Colors.grey[200],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (val) {
            if (val == null && validationMessage != null) {
              return validationMessage;
            }
            return null;
          },
          isExpanded: true,
          alignment: AlignmentDirectional.centerEnd,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildCubit, ChildState>(
      listener: (context, state) {
        if (state is ChildDetailsLoaded) {
          _populateFormFields(state.childDetail);
        } else if (state is ChildDetailsError) {
          setState(() {
            _isLoadingDetails = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('خطأ في تحميل بيانات الطفل: ${state.message}')),
          );
        }
        // TODO: Handle ChildSaving, ChildSavedSuccess, ChildSaveError states
      },
      
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: TopBar(title: "مستوصف باشراحيل"),
          ),
          body: _isLoadingDetails
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                            _isEditMode
                                ? 'تعديل بيانات الطفل'
                                : 'إضافة طفل جديد',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'الاسم الاول', _firstNameController,
                                    hint: 'ادخل الاسم الأول')),
                            const SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                                    'الاسم الاخير', _lastNameController,
                                    hint: 'ادخل الاسم الاخير')),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                'تاريخ الميلاد',
                                TextEditingController(
                                    text: _selectedBirthDate != null
                                        ? _displayDateFormat
                                            .format(_selectedBirthDate!)
                                        : ""),
                                hint: 'يوم/شهر/سنة',
                                isDate: true,
                                onDateTap: () => _selectDate(
                                    context,
                                    (date) => setState(
                                        () => _selectedBirthDate = date),
                                    initialDate: _selectedBirthDate),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField('رقم بطاقة التطعيم',
                                    _vaccineCardNumberController)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildRadioGroup<String>(
                                'الجنس',
                                _selectedGender,
                                ['ذكر', 'أنثى'],
                                ['ذكر', 'أنثى'],
                                (value) =>
                                    setState(() => _selectedGender = value),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildRadioGroup<String>(
                                'نوع الشهادة',
                                _selectedCertificateType,
                                ['داخلية', 'خارجية'],
                                ['داخلية', 'خارجية'],
                                (value) {
                                  setState(() {
                                    _selectedCertificateType = value;
                                    if (value == 'داخلية')
                                      _selectedBirthIssuanceCountry = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildTextField('رقم شهادة الميلاد',
                            _birthCertificateNumberController),
                        const SizedBox(height: 16),

                        _buildDropdownField<NationalityOptionModel>(
                          label: 'الجنسية',
                          value: _selectedNationality,
                          items: _nationalityOptions,
                          itemText: (NationalityOptionModel opt) =>
                              opt.nationalityName,
                          onChanged: (val) =>
                              setState(() => _selectedNationality = val),
                          validationMessage: 'الرجاء اختيار الجنسية',
                        ),
                        const SizedBox(height: 16),

                        if (_selectedCertificateType == 'خارجية') ...[
                          _buildDropdownField<CountryOptionModel>(
                            label: 'بلد اصدار الشهادة',
                            value: _selectedBirthIssuanceCountry,
                            items: _countryOptions,
                            itemText: (CountryOptionModel opt) =>
                                opt.countryName,
                            onChanged: (val) => setState(
                                () => _selectedBirthIssuanceCountry = val),
                            validationMessage: 'الرجاء اختيار بلد الاصدار',
                          ),
                          const SizedBox(height: 16),
                        ],

                        _buildRadioGroup<bool>(
                            'هل لديه حالة خاصة',
                            _hasSpecialCase,
                            [true, false],
                            ['نعم', 'لا'],
                            (value) => setState(
                                () => _hasSpecialCase = value ?? false)),
                        const SizedBox(height: 16),

                        if (_hasSpecialCase) ...[
                          _buildDropdownField<SpecialCaseOptionModel>(
                            label: 'نوع الحالة الخاصة',
                            value: _selectedSpecialCaseType,
                            items: _specialCaseTypeOptions,
                            itemText: (SpecialCaseOptionModel opt) =>
                                opt.specialCaseName,
                            onChanged: (val) =>
                                setState(() => _selectedSpecialCaseType = val),
                            validationMessage: 'الرجاء اختيار نوع الحالة',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField('وصف الحالة الخاصة',
                              _specialCaseDescriptionController,
                              hint: 'ادخل وصف الحالة (اختياري)'),
                          const SizedBox(height: 16),
                          _buildTextField(
                            'متى بدأت الحالة',
                            TextEditingController(
                                text: _selectedSpecialCaseStartDate != null
                                    ? _displayDateFormat
                                        .format(_selectedSpecialCaseStartDate!)
                                    : ""),
                            hint: 'يوم/شهر/سنة',
                            isDate: true,
                            onDateTap: () => _selectDate(
                                context,
                                (date) => setState(
                                    () => _selectedSpecialCaseStartDate = date),
                                initialDate: _selectedSpecialCaseStartDate),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // TODO: Searchable Parent Fields (اختر الأب, اختر الأم) will require more complex widgets

                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoadingDetails ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                              _isEditMode ? 'حفظ التعديلات' : 'إضافة طفل',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
*/
