import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/Core/theme/styles.dart';

class SideNav extends StatefulWidget {
  final String userName;
  final String userRole;
  final List<Map<String, dynamic>> menuItems;
  final Function(String)? onMenuItemTap;
  const SideNav({
    super.key,
    required this.userName,
    required this.userRole,
    required this.menuItems,
    this.onMenuItemTap,
  });
  @override
  State<SideNav> createState() => _Sidebar1State();
}

class _Sidebar1State extends State<SideNav> {
  String userName = 'اسم المستخدم';
  String userRole = 'دور المستخدم';
  List<Map<String, dynamic>>? menuItems;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    menuItems = MenuItemsHelper.getMenuItems(userRole);
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await StorageHelper.getSavedUserData();
      setState(() {
        userName = userData.userName ?? 'زائر';
        userRole = userData.role ?? 'مستخدم';
        menuItems = MenuItemsHelper.getMenuItems(userRole);
      });
    } catch (e) {
      setState(() {
        userName = 'زائر';
        userRole = 'مستخدم';
        menuItems = MenuItemsHelper.getDefaultMenu(); // قائمة افتراضية
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // البحث مع معالجة عدم الوجود
    final menuItemsForRole = menuItems?.firstWhere(
      (item) => item['role'] == userRole.toLowerCase(),
      orElse: () => MenuItemsHelper.getDefaultMenu().first, // افتراضي
    );

    return Container(
      width: 289,
      padding: const EdgeInsets.all(16),
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Icon(Icons.person, size: 60, color: AppColors.navColor),
          const SizedBox(height: 10),
          Text(userName,
              style:
                  const TextStyle(color: AppColors.textColor2, fontSize: 16)),
          Text(userRole,
              style:
                  const TextStyle(color: AppColors.textColor2, fontSize: 14)),
          const SizedBox(height: 20),
          Expanded(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  (menuItemsForRole?["items"] as List?)?.map<Widget>((item) {
                        return _buildFunctionCard(
                          icon: item["icon"],
                          label: item["label"],
                          route: item["route"],
                          onTap: () => context.pushNamed(item["route"]),
                        );
                      }).toList() ??
                      [
                        // <-- قيمة افتراضية فارغة
                        const Center(
                          child: Text('لا توجد عناصر متاحة'),
                        )
                      ],
            ),
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildFunctionCard({
    required IconData icon,
    required String label,
    required String route,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 130,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.navColor),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.navtext,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await StorageHelper.removeData(SharedPrefKeys.userToken);
        await StorageHelper.removeData(SharedPrefKeys.userId);
        await StorageHelper.removeData(SharedPrefKeys.userRole);
        await StorageHelper.removeData(SharedPrefKeys.userName);
        await StorageHelper.removeData(SharedPrefKeys.centerId);

        if (mounted) context.pushReplacementNamed('/login');
      },
      icon: const Icon(Icons.logout, color: AppColors.white),
      label: const Text('تسجيل خروج',
          style: TextStyle(color: AppColors.white, fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
