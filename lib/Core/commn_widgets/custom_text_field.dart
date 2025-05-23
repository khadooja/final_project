import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/Core/utils/form_validators.dart';


enum InputType { text, number, email, date, dropdown, radio, location, phone }


class CustomInputField extends StatefulWidget {
  final String label;
  final InputType keyboardType;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isObscureText;
final List<dynamic>? dropdownItems;
final List<String>? dropdownItems1;

  final List<String>? radioOptions;
  final String? hintText;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final Future<List<dynamic>> Function()? fetchLocations;
  final String? cityId;
  final String? areaId;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomInputField({
    super.key,
    required this.label,
    this.keyboardType = InputType.text,
    this.isObscureText = false,
    this.controller,
    this.initialValue,
    this.dropdownItems,
    this.dropdownItems1,
    this.radioOptions,
    this.selectedValue,
    this.hintText,
    this.onChanged,
    this.fetchLocations,
    this.cityId,
    this.areaId,
    this.validator,
    this.prefixIcon,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isObscureText = true;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.keyboardType) {
      case InputType.text:
        return _buildTextInput();
      case InputType.date:
        return _buildDateInput(context);
      case InputType.dropdown:
  return _buildGenericDropdown(
    label: widget.label,
    value: widget.selectedValue,
    items: widget.dropdownItems ?? [],
    displayText: (item) => item.toString(),
    onChanged: (dynamic value) => widget.onChanged?.call(value?.toString()),
  );

      case InputType.radio:
        return _buildRadio();
      case InputType.location:
        return _buildLocation();
      default:
        return _buildTextInput();
    }
  }

  Widget _buildTextInput() {
    return SizedBox(
      width: 506,
      height: 80,
      child: TextFormField(
        controller: widget.controller ??
            TextEditingController(text: widget.initialValue),
        obscureText: widget.isObscureText && _isObscureText,
        textAlign: TextAlign.right,

        decoration: _inputDecoration(labelText: widget.label),
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator ??
            (value) => validateNotEmpty(value, fieldName: widget.label),
      ),
    );
  }

  Widget _buildDateInput(BuildContext context) {
    return SizedBox(
      width: 506,
      height: 80,
      child: TextFormField(
        controller: widget.controller ??
            TextEditingController(text: widget.initialValue),
        textAlign: TextAlign.right,
        decoration: _inputDecoration(),
        validator: widget.validator ??
            (value) => validateNotEmpty(value, fieldName: widget.label),
        readOnly: true,
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (selectedDate != null) {
            final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
            widget.controller?.text = formattedDate;
          }
        },
      ),
    );
  }

  Widget _buildDropdown() {
    return SizedBox(
      width: 506,
      height: 80,
      child: DropdownButtonFormField<String>(
        value: widget.selectedValue,
        items: widget.dropdownItems1
            ?.map((item) =>
                DropdownMenuItem(value: item, child: _rightAlignedText(item)))
            .toList(),
        onChanged: widget.onChanged,
        decoration: _inputDecoration(),
        validator: widget.validator ??
            (value) => validateNotEmpty(value, fieldName: widget.label),
      ),
    );
  }

Widget _buildRadio() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      _buildAlignedLabel(),
      ...?widget.radioOptions?.map(
        (option) => RadioListTile<String>(
          title: _rightAlignedText(option),
          value: option,
          groupValue: widget.selectedValue,
          onChanged: widget.onChanged,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    ],
  );
}

  Widget _buildLocation() {
    return FutureBuilder<List<dynamic>>(
      future: widget.fetchLocations?.call(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text("فشل في تحميل البيانات");
        }

        final locations = snapshot.data!;
        return Column(
          children: [
            _buildDropdownWithItems(
              label: "اختر المدينة",
              value: widget.cityId,
              items: locations.map((loc) => loc['id'].toString()).toList(),
              displayText: (id) => locations
                  .firstWhere((loc) => loc['id'].toString() == id)['city_name'],
            ),
            const SizedBox(height: 8),
            _buildDropdownWithItems(
              label: "اختر الحي",
              value: widget.areaId,
              items: locations
                  .where((loc) => loc['city_id'].toString() == widget.cityId)
                  .map((loc) => loc['id'].toString())
                  .toList(),
              displayText: (id) => locations
                  .firstWhere((loc) => loc['id'].toString() == id)['area_name'],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownWithItems({
    required String label,
    required String? value,
    required List<String> items,
    required String Function(String) displayText,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((id) => DropdownMenuItem(
              value: id, child: _rightAlignedText(displayText(id))))
          .toList(),
      onChanged: widget.onChanged,
      decoration: _inputDecoration(labelText: label),
      validator: widget.validator ??
          (value) => validateNotEmpty(value, fieldName: label),
    );
  }
  Widget _buildGenericDropdown<T>({
  required String label,
  required T? value,
  required List<T> items,
  required String Function(T) displayText,
  required void Function(T?) onChanged,
  FormFieldValidator<T>? validator,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    items: items
        .map((item) => DropdownMenuItem<T>(
              value: item,
              child: _rightAlignedText(displayText(item)),
            ))
        .toList(),
    onChanged: onChanged,
    decoration: _inputDecoration(labelText: label),
    validator: validator ??
        (val) => val == null ? 'يرجى اختيار $label' : null,
  );
}


  InputDecoration _inputDecoration({
    String? labelText,
    IconData? icon,
  }) {
    final showEyeIcon = widget.isObscureText;

    return InputDecoration(
      label: labelText != null
          ? _rightAlignedText(labelText)
          : _buildAlignedLabel(),
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFD9D6D6), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 3),
      ),
      filled: true,
      fillColor: const Color(0xFFEEEEEE),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

      suffixIcon: (!showEyeIcon && widget.prefixIcon != null)
          ? widget.prefixIcon
          : null,
      prefixIcon: showEyeIcon
          ? IconButton(
              icon: Icon(
                _isObscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscureText = !_isObscureText;
                });
              },
            )
          : null,
    );
  }

  Widget _buildAlignedLabel() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(widget.label, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _rightAlignedText(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(text),
    );
  }
}
