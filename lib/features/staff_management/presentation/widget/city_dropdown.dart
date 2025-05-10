import 'package:flutter/material.dart';
import 'add_location_dialog.dart';

class CityDropdown extends StatefulWidget {
  final List<dynamic> cities;
  final Function(String?) onChanged;
  final Function(String) onCityAdded;

  const CityDropdown({
    super.key,
    required this.cities,
    required this.onChanged,
    required this.onCityAdded,
  });

  @override
  _CityDropdownState createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedCity,
          hint: const Text('اختر المدينة'),
          items: widget.cities.map((city) {
            return DropdownMenuItem(
              value: city['id'].toString(),
              child: Text(city['name']),
            );
          }).toList()
            ..add(const DropdownMenuItem(
              value: 'add_new',
              child: Text('إضافة مدينة جديدة'),
            )),
          onChanged: (value) {
            if (value == 'add_new') {
              _showAddCityDialog();
            } else {
              setState(() {
                selectedCity = value;
              });
              widget.onChanged(value);
            }
          },
        ),
      ],
    );
  }

  void _showAddCityDialog() {
    showDialog(
      context: context,
      builder: (_) => AddLocationDialog(
        locationType: 'مدينة',
        onLocationAdded: (newCity) {
          setState(() {
            final newId = DateTime.now().millisecondsSinceEpoch.toString();
            widget.cities.add({'id': newId, 'name': newCity});
            selectedCity = newId;
          });
          widget.onCityAdded(newCity);
        },
      ),
    );
  }
}
