import 'package:flutter/material.dart';
import 'add_location_dialog.dart';

class StreetDropdown extends StatefulWidget {
  final List<dynamic> streets;
  final Function(String?) onChanged;
  final Function(String) onStreetAdded;

  const StreetDropdown({
    super.key,
    required this.streets,
    required this.onChanged,
    required this.onStreetAdded,
  });

  @override
  _StreetDropdownState createState() => _StreetDropdownState();
}

class _StreetDropdownState extends State<StreetDropdown> {
  String? selectedStreet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedStreet,
          hint: const Text('اختر الشارع'),
          items: widget.streets.map((street) {
            return DropdownMenuItem(
              value: street['id'].toString(),
              child: Text(street['name']),
            );
          }).toList()
            ..add(const DropdownMenuItem(
              value: 'add_new',
              child: Text('إضافة شارع جديد'),
            )),
          onChanged: (value) {
            if (value == 'add_new') {
              _showAddStreetDialog();
            } else {
              setState(() {
                selectedStreet = value;
              });
              widget.onChanged(value);
            }
          },
        ),
      ],
    );
  }

  void _showAddStreetDialog() {
    showDialog(
      context: context,
      builder: (_) => AddLocationDialog(
        locationType: 'شارع',
        onLocationAdded: (newStreet) {
          setState(() {
            final newId = DateTime.now().millisecondsSinceEpoch.toString();
            widget.streets.add({'id': newId, 'name': newStreet});
            selectedStreet = newId;
          });
          widget.onStreetAdded(newStreet);
        },
      ),
    );
  }
}
