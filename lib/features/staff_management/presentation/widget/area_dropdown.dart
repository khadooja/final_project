import 'package:flutter/material.dart';
import 'add_location_dialog.dart';

class AreaDropdown extends StatefulWidget {
  final List<dynamic> areas;
  final Function(String?) onChanged;
  final Function(String) onAreaAdded;

  const AreaDropdown({
    super.key,
    required this.areas,
    required this.onChanged,
    required this.onAreaAdded,
  });

  @override
  _AreaDropdownState createState() => _AreaDropdownState();
}

class _AreaDropdownState extends State<AreaDropdown> {
  String? selectedArea;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedArea,
          hint: const Text('اختر الحي'),
          items: widget.areas.map((area) {
            return DropdownMenuItem(
              value: area['id'].toString(),
              child: Text(area['name']),
            );
          }).toList()
            ..add(const DropdownMenuItem(
              value: 'add_new',
              child: Text('إضافة حي جديد'),
            )),
          onChanged: (value) {
            if (value == 'add_new') {
              _showAddAreaDialog();
            } else {
              setState(() {
                selectedArea = value;
              });
              widget.onChanged(value);
            }
          },
        ),
      ],
    );
  }

  void _showAddAreaDialog() {
    showDialog(
      context: context,
      builder: (_) => AddLocationDialog(
        locationType: 'حي',
        onLocationAdded: (newArea) {
          setState(() {
            final newId = DateTime.now().millisecondsSinceEpoch.toString();
            widget.areas.add({'id': newId, 'name': newArea});
            selectedArea = newId;
          });
          widget.onAreaAdded(newArea);
        },
      ),
    );
  }
}
