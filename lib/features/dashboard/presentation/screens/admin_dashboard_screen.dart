import 'package:flutter/material.dart';
import 'package:new_project/features/dashboard/presentation/widgets/managerDashboardScreen.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseDashboardScreen(
      defaultRole: 'manager',
      title: 'لوحة تحكم المسؤول',
    );
  }
}