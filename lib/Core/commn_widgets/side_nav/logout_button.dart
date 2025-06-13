import 'package:flutter/material.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/auth/presentation/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await StorageHelper.removeData(SharedPrefKeys.userToken);
      await StorageHelper.removeData(SharedPrefKeys.userId);
      await StorageHelper.removeData(SharedPrefKeys.userRole);
      await StorageHelper.removeData(SharedPrefKeys.userName);
      await StorageHelper.removeData(SharedPrefKeys.centerId);

      // استخدم rootNavigator هنا
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Logout Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء تسجيل الخروج')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _logout(context),
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
