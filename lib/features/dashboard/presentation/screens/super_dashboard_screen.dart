import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/main_layout.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:new_project/features/dashboard/presentation/widgets/dashboard_section.dart';

class SuperDashboardScreen extends StatefulWidget {
  const SuperDashboardScreen({super.key});

  @override
  _SuperDashboardScreenState createState() => _SuperDashboardScreenState();
}

class _SuperDashboardScreenState extends State<SuperDashboardScreen> {
  late Future<LoginResponse> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Future<LoginResponse> _loadUserData() async {
    try {
      return await StorageHelper.getSavedUserData();
    } catch (e) {
      // في حال الخطأ، يمكنك إعادة مستخدم افتراضي أو عرض رسالة
      return LoginResponse(
        userName: 'محمد خالد',
        role: 'admin', // افتراضي للعرض فقط
      );
    }
  }

  void _handleMenuItemTap(String routeName) {
    if (routeName == '/logout') {
      _logout();
    } else {
      context.pushNamed(routeName);
    }
  }

  void _logout() async {
    await StorageHelper.removeData(SharedPrefKeys.userToken);
    await StorageHelper.removeData(SharedPrefKeys.userId);
    await StorageHelper.removeData(SharedPrefKeys.userRole);
    await StorageHelper.removeData(SharedPrefKeys.userName);
    await StorageHelper.removeData(SharedPrefKeys.centerId);

    if (mounted) {
      context.pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textBox,
      body: FutureBuilder<LoginResponse>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء تحميل البيانات'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return MainLayout(
              title: "لوحة التحكم",
              userName: userData.userName ?? 'اسم المستخدم',
              userRole: userData.role ?? 'دور المستخدم',
              menuItems: MenuItemsHelper.getMenuItems(userData.role ?? 'admin'),
              onMenuItemTap: _handleMenuItemTap,
              child: DashboardSection(
                  role: userData.role ?? 'admin'), // تمرير الدور
            );
          } else {
            return const Center(child: Text('لا توجد بيانات'));
          }
        },
      ),
    );
  }
}
