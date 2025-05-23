import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart'
    as coreWidgets;
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/features/HelthCenter/logic/cubit/health_center_cubit.dart';
import 'package:new_project/features/HelthCenter/model/helth_center.dart';
import 'package:new_project/features/HelthCenter/model/location.dart';

import '../../vaccination/vaccine/presentation/CustomAppBar.dart';

class HealthCenterForm extends StatefulWidget {
  const HealthCenterForm({super.key});

  @override
  State<HealthCenterForm> createState() => _HealthCenterFormState();
}

class _HealthCenterFormState extends State<HealthCenterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Location? _selectedCity;
  Location? _selectedArea;

  List<Location> _cities = [];
  List<Location> _areas = [];

  bool _isSubmitting = false;

  void _submit() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
      );
      return;
    }

    final center = HealthCenter(
      id: 0,
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      locationId: _selectedArea!.id,
    );

    setState(() => _isSubmitting = true);
    context.read<HealthCenterCubit>().addCenter(center);
  }

  @override
  void initState() {
    super.initState();
    context.read<HealthCenterCubit>().fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(title: "إضافة مستوصف جديد"),
      ),
      body: BlocConsumer<HealthCenterCubit, HealthCenterState>(
        listener: (context, state) {
          if (state is CitiesLoaded) {
            setState(() {
              _cities = state.cities;
              _selectedCity = null;
              _areas = [];
              _selectedArea = null;
            });
          } else if (state is AreasLoaded) {
            setState(() {
              _areas = state.areas;
              _selectedArea = _areas.isNotEmpty ? _areas.first : null;
            });
          } else if (state is HealthCenterAdded) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة المركز الصحي بنجاح')),
            );
            Navigator.pop(context, true);
          } else if (state is HealthCenterError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return _cities.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomInputField(
                                    label: 'اسم المركز الصحي',
                                    controller: _nameController,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomInputField(
                                    label: 'رقم الجوال',
                                    controller: _phoneController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomDropdown<Location>(
                              label: 'المدينة',
                              value: _selectedCity,
                              items: _cities.map((city) {
                                return DropdownMenuItem<Location>(
                                  value: city,
                                  child: Text(city.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCity = value;
                                  _selectedArea = null;
                                  _areas = [];
                                });

                                if (value != null) {
                                  context
                                      .read<HealthCenterCubit>()
                                      .fetchAreas(value.name);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            if (_areas.isNotEmpty)
                              CustomDropdown<Location>(
                                label: 'المنطقة',
                                value: _selectedArea,
                                items: _areas.map((area) {
                                  return DropdownMenuItem<Location>(
                                    value: area,
                                    child: Text(area.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedArea = value);
                                },
                              ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 200,
                                child: coreWidgets.CustomButton(
                                  text: _isSubmitting
                                      ? 'جاري الإرسال...'
                                      : 'إضافة',
                                  onPressed: () {
                                    if (_isSubmitting) return;
                                    _submit();
                                  },
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
