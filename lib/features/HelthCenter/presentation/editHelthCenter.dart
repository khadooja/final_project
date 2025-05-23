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

class EditHealthCenterScreen extends StatefulWidget {
  final HealthCenter healthCenter;
  const EditHealthCenterScreen({super.key, required this.healthCenter});

  @override
  State<EditHealthCenterScreen> createState() => _EditHealthCenterScreenState();
}

class _EditHealthCenterScreenState extends State<EditHealthCenterScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

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

    final updatedCenter = HealthCenter(
      id: widget.healthCenter.id,
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      locationId: _selectedArea!.id,
    );

    setState(() => _isSubmitting = true);
    context.read<HealthCenterCubit>().updateHealthCenter(
          id: updatedCenter.id,
          model: updatedCenter,
        );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.healthCenter.name);
    _phoneController =
        TextEditingController(text: widget.healthCenter.phoneNumber);
    context.read<HealthCenterCubit>().fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: BlocConsumer<HealthCenterCubit, HealthCenterState>(
            listener: (context, state) {
              if (state is CitiesLoaded) {
                setState(() {
                  _cities = state.cities;
                  _selectedCity = _cities.firstWhere(
                    (c) => c.id == widget.healthCenter.locationId,
                    orElse: () => _cities.first,
                  );
                  context
                      .read<HealthCenterCubit>()
                      .fetchAreas(_selectedCity!.name);
                });
              } else if (state is AreasLoaded) {
                setState(() {
                  _areas = state.areas;
                  _selectedArea = _areas.firstWhere(
                    (a) => a.id == widget.healthCenter.locationId,
                    orElse: () => _areas.first,
                  );
                });
              } else if (state is HealthCenterUpdated) {
                setState(() => _isSubmitting = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تعديل المركز الصحي بنجاح')),
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
              if (_cities.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TopBar(title: "تعديل مستوصف"),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
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
                                          ? 'جاري التعديل...'
                                          : 'تعديل',
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
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
