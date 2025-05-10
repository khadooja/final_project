import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/features/dashboard/presentation/widgets/dashboard_section.dart';
import 'package:new_project/Core/commn_widgets/main_layout.dart';

class Staffdashboardscreen extends StatefulWidget {
  const Staffdashboardscreen({super.key});

  @override
  State<Staffdashboardscreen> createState() => _Staffdashboardscreen();
}

class _Staffdashboardscreen extends State<Staffdashboardscreen> {
  String userName = '';
  String userRole = '';
  List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name =
        await StorageHelper.getSecuredString(SharedPrefKeys.userName) ??
            'اسم المستخدم';
    final role =
        await StorageHelper.getSecuredString(SharedPrefKeys.userRole) ??
            'دور غير معروف';

    setState(() {
      userName = name;
      userRole = role;
      menuItems = MenuItemsHelper.getMenuItems(role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "لوحة التحكم",
      userName: userName,
      userRole: userRole,
      menuItems: menuItems,
      child: const DashboardSection(),
    );
  }
}
