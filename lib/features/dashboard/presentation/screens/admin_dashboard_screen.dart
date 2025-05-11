/*import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/dashboardcard.dart';
import 'package:new_project/Core/commn_widgets/sidebar.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 246, 247),
      body: Row(
        children: [
          const Sidebar(
            userName: "خالد محمد",
            userRole: "مدير مستوصف",
            menuItems: [
              {
                "icon": Icons.account_circle,
                "label": "الملف الشخصي",
                "route": Routes.profile
              },
              {
                "icon": Icons.person_add,
                "label": "إضافة موظف",
                "route": Routes.addEmployee
              },
              {
                "icon": Icons.people,
                "label": "عرض الموظفين",
                "route": Routes.viewEmployees
              },
              {
                "icon": Icons.child_care,
                "label": "إضافة طفل",
                "route": Routes.addChild
              },
              {
                "icon": Icons.list,
                "label": "عرض الأطفال",
                "route": Routes.viewChildren
              },
            ],
          ),
          Expanded(
            child: Column(
              children: [
                const TopBar(), // الشعار + البحث
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2, // عدد الأعمدة
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 3.0, //تقليص الحجم
                      children: [
                        DashboardCard(
                          icon: Icons.list,
                          title: "عرض الأطفال",
                          onTap: () {
                            Navigator.pushNamed(context, Routes.viewChildren);
                          },
                        ),
                        DashboardCard(
                          icon: Icons.child_care,
                          title: "إضافة طفل",
                          onTap: () {
                            Navigator.pushNamed(context, Routes.addChild);
                          },
                        ),
                        DashboardCard(
                            icon: Icons.people,
                            title: "عرض بيانات الموظفين",
                            onTap: () {
                              List<EmployeeModel> employees =
                                  []; // هنا يجب أن تحتوي على بيانات الموظفين من الـ API
                              Navigator.pushNamed(context, Routes.viewEmployees,
                                  arguments: employees);
                            }),
                        DashboardCard(
                          icon: Icons.person_add,
                          title: "إضافة موظف",
                          onTap: () {
                            Navigator.pushNamed(context, Routes.addEmployee);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

/*
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String userName = '';
  String userRole = '';
  List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // استرجاع البيانات من Shared Preferences
    final userData = await SharedPrefHelper.getSavedTokenData();

    print('User Dataزززززززززززززززززززززززززززززززززززززز: $userData');
    setState(() {
      userName = userData.userName ?? 'اسم المستخدم';
      userRole = userData.role ?? 'دور المستخدم';
      menuItems = MenuItemsHelper.getMenuItems(userRole);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ عرض مؤقت أثناء تحميل البيانات
    if (userName.isEmpty || userRole.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MainLayout(
      title: "لوحة التحكم",
      userName: userName,
      userRole: userRole,
      menuItems: menuItems,
      child: const DashboardSection(),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/main_layout.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/auth/data/model/login_response.dart';
import 'package:new_project/features/dashboard/presentation/widgets/dashboard_section.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
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
