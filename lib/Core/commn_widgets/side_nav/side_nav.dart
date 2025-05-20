import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/side_nav/function_card.dart';
import 'package:new_project/Core/commn_widgets/side_nav/logout_button.dart';
import 'package:new_project/Core/commn_widgets/side_nav/user_header.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/theme/colors.dart';

class SideNav extends StatefulWidget {
  const SideNav({super.key});
  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  String userName = 'اسم المستخدم';
  String userRole = 'دور المستخدم';
  List<Map<String, dynamic>>? menuItems;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final name =
          await StorageHelper.getData(SharedPrefKeys.userName, isSecure: true);
      final role =
          await StorageHelper.getData(SharedPrefKeys.userRole, isSecure: true);
      setState(() {
        userName = name ?? 'زائر';
        userRole = role ?? 'مستخدم';
        menuItems = MenuItemsHelper.getMenuItems(role ?? 'مستخدم');
      });
    } catch (_) {
      setState(() {
        userName = 'زائر';
        userRole = 'مستخدم';
        menuItems = MenuItemsHelper.getMenuItems('مستخدم');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItemsForRole = menuItems?.firstWhere(
      (p) => p["role"] == userRole,
      orElse: () => {},
    );

    return Container(
      width: 289,
      padding: const EdgeInsets.all(16),
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 10),
          UserHeader(name: userName, role: userRole),
          const SizedBox(height: 20),
          Expanded(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  (menuItemsForRole?["items"] as List?)?.map<Widget>((item) {
                        return FunctionCard(
                          icon: item["icon"],
                          label: item["label"],
                          onTap: () => context.pushNamed(item["route"]),
                        );
                      }).toList() ??
                      [const Center(child: Text('لا توجد عناصر متاحة'))],
            ),
          ),
          const SizedBox(height: 20),
          const LogoutButton(),
        ],
      ),
    );
  }
}
