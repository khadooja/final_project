import 'package:flutter/material.dart';

class LocationSelection extends StatefulWidget {
  const LocationSelection({super.key});

  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  String? selectedCity;
  String? selectedArea;
  String? selectedStreet;

  List<String> cities = ['جدة', 'الرياض', 'مكة']; // البيانات تأتي من API
  List<String> areas = [];
  List<String> streets = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          hint: const Text('اختر المدينة'),
          items: cities.map((city) {
            return DropdownMenuItem(value: city, child: Text(city));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
              areas = ['حي النسيم', 'حي الشفا']; // جلب الأحياء من API
            });
          },
        ),
        DropdownButtonFormField<String>(
          hint: const Text('اختر الحي'),
          items: areas.map((area) {
            return DropdownMenuItem(value: area, child: Text(area));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedArea = value;
              streets = [
                'شارع الملك عبدالعزيز',
                'شارع العليا'
              ]; // جلب الشوارع من API
            });
          },
        ),
        DropdownButtonFormField<String>(
          hint: const Text('اختر الشارع'),
          items: streets.map((street) {
            return DropdownMenuItem(value: street, child: Text(street));
          }).toList(),
          onChanged: (value) => setState(() => selectedStreet = value),
        ),
      ],
    );
  }
}
