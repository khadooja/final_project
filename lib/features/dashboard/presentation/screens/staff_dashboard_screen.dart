import 'package:flutter/material.dart';
import 'package:new_project/features/dashboard/presentation/widgets/managerDashboardScreen.dart';

class Staffdashboardscreen extends StatelessWidget {
  const Staffdashboardscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseDashboardScreen(
      defaultRole: 'staff',
      title: 'لوحة تحكم المسؤول',
    );
  }
}
