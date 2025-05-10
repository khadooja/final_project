import 'package:flutter/material.dart';

class TestFormScreen extends StatelessWidget {
  final Widget Function() buildFullForm;

  const TestFormScreen({super.key, required this.buildFullForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildFullForm(),
      ),
    );
  }
}
