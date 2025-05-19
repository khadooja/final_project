import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/main_layout.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:new_project/features/dashboard/presentation/widgets/dashboard_section.dart';

class BaseDashboardScreen extends StatefulWidget {
  final String defaultRole;
  final String title;

  const BaseDashboardScreen({
    super.key,
    required this.defaultRole,
    required this.title,
  });

  @override
  _BaseDashboardScreenState createState() => _BaseDashboardScreenState();
}

class _BaseDashboardScreenState extends State<BaseDashboardScreen> {
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
      return LoginResponse(
        userName: 'اسم المستخدم',
        role: widget.defaultRole, 
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
    await StorageHelper.removeData('userToken');
    await StorageHelper.removeData('userId');
    await StorageHelper.removeData('userRole');
    await StorageHelper.removeData('userName');
    await StorageHelper.removeData('centerId');

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
              title: widget.title,
              userName: userData.userName ?? 'اسم المستخدم',
              userRole: userData.role ?? widget.defaultRole,
              menuItems: MenuItemsHelper.getMenuItems(userData.role ?? widget.defaultRole),
              onMenuItemTap: _handleMenuItemTap,
              child: DashboardSection(role: userData.role ?? widget.defaultRole),
            );
          } else {
            return const Center(child: Text('لا توجد بيانات'));
          }
        },
      ),
    );
  }
}
