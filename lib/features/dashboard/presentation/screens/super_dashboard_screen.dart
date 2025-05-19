import 'package:flutter/material.dart';
import 'package:new_project/features/dashboard/presentation/widgets/managerDashboardScreen.dart';

class SuperDashboardScreen extends StatelessWidget {
  const SuperDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseDashboardScreen(
      defaultRole: 'supervisor',
      title: 'لوحة تحكم المسؤول',
    );
  }
}