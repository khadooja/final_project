import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  final String? message;
  const DummyPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(message ?? "Dummy Page")),
      body: Center(
          child: Text("This is a dummy page. Message: ${message ?? 'None'}")),
    );
  }
}
