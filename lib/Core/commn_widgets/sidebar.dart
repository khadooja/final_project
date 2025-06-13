import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/side_nav/logout_button.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/Core/theme/styles.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;
  final Function(String)? onItemTap;

  const Sidebar({
    super.key,
    required this.menuItems,
    this.onItemTap,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String userName = '';
  String userRole = '';

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
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        userName = 'زائر';
        userRole = 'مستخدم';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      color: AppColors.white,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryColor,
            child: Icon(
              Icons.person,
              size: 50,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(userName, style: AppTextStyles.textNav),
          Text(userRole, style: AppTextStyles.textNav),
          const SizedBox(height: 20),

          // قائمة التنقل
          ...widget.menuItems.map((item) {
            final icon = item['icon'] as IconData?;
            final label = item['label'] as String?;
            final route = item['route'] as String?;

            if (icon != null && label != null && route != null) {
              return _buildNavItem(icon, label, route, context);
            } else {
              return const SizedBox();
            }
          }).toList(),

          const Spacer(),
          const LogoutButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, String routeName, BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label,
              style:
                  const TextStyle(color: AppColors.textColor2, fontSize: 22)),
          const SizedBox(width: 8),
          Icon(icon, color: AppColors.primaryColor, size: 30),
        ],
      ),
      onTap: () {
        if (widget.onItemTap != null) {
          widget.onItemTap!(routeName);
        } else {
          context.pushNamed(routeName);
        }
      },
    );
  }

  /* Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await StorageHelper.removeData(SharedPrefKeys.userToken);
        await StorageHelper.removeData(SharedPrefKeys.userId);
        await StorageHelper.removeData(SharedPrefKeys.userRole);
        await StorageHelper.removeData(SharedPrefKeys.userName);
        await StorageHelper.removeData(SharedPrefKeys.centerId);

        if (mounted) {
          context.pushReplacementNamed('/login');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('تسجيل خروج',
              style: TextStyle(color: AppColors.white, fontSize: 24)),
          SizedBox(width: 10),
          Icon(Icons.logout, color: AppColors.white),
        ],
      ),
    );
  }*/
}
