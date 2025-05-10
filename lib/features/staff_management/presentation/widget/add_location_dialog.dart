import 'package:flutter/material.dart';

class AddLocationDialog extends StatefulWidget {
  final String locationType;
  final Function(String) onLocationAdded;

  const AddLocationDialog({
    super.key,
    required this.locationType,
    required this.onLocationAdded,
  });

  @override
  _AddLocationDialogState createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  final TextEditingController _locationController = TextEditingController();

  void _addLocation() {
    if (_locationController.text.isNotEmpty) {
      widget.onLocationAdded(_locationController.text);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال اسم ${widget.locationType}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة ${widget.locationType}'),
      content: TextField(
        controller: _locationController,
        decoration: InputDecoration(
          hintText: 'أدخل ${widget.locationType} الجديد',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: _addLocation,
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
