import 'package:flutter/material.dart';
import 'package:new_project/features/children_managment/presentation/widget/addChildForm.dart';

class AddChildScreen extends StatelessWidget {
  final int fatherId;
  final int motherId;

  const AddChildScreen({
    super.key,
    required this.fatherId,
    required this.motherId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة طفل")),
      body: AddChildForm(fatherId: fatherId, motherId: motherId),
    );
  }
}
