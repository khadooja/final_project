import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/commn_widgets/sideNav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/family_management/presentation/father_form_section.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';

class FatherScreen extends StatefulWidget {
  const FatherScreen({super.key});

  @override
  State<FatherScreen> createState() => _FatherScreenState();
}

class _FatherScreenState extends State<FatherScreen> {
  bool showForm = false;

  Future<Map<String, String>> _loadUserData() async {
    try {
      final userData = await StorageHelper.getSavedUserData();
      return {
        'userName': userData.userName ?? 'زائر',
        'userRole': userData.role ?? 'مستخدم',
      };
    } catch (e) {
      return {
        'userName': 'زائر',
        'userRole': 'مستخدم',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<FatherCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<Map<String, String>>(
          future: _loadUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final userName = snapshot.data?['userName'] ?? 'زائر';
            final userRole = snapshot.data?['userRole'] ?? 'مستخدم';

            return Scaffold(
              backgroundColor: AppColors.white,
              body: Row(
                children: [
                  // المحتوى الرئيسي (على اليسار)
                  Expanded(
                    child: Column(
                      children: [
                        const TopBar(title: "إضافة أب"),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                SearchIdentitySection(
                                  type: 'father',
                                  onSearchCompleted: (found) {
                                    setState(() => showForm = found);
                                  },
                                ),
                                const SizedBox(height: 20),
                                if (showForm)
                                  Expanded(
                                    child:
                                        BlocBuilder<FatherCubit, FatherState>(
                                      builder: (context, state) {
                                        if (state is FatherLoading) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return const FatherFormSection();
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // الشريط الجانبي (على اليمين)
                  SizedBox(
                    width: 300, // عرض ثابت
                    child: SideNav(
                      userName: userName,
                      userRole: userRole,
                      menuItems: MenuItemsHelper.getMenuItems(userRole),
                      onMenuItemTap: (routeName) {
                        Navigator.pushNamed(context, routeName);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}









/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/menuItemsHelper.dart';
import 'package:new_project/Core/commn_widgets/sideNav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/family_management/presentation/father_form_section.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';

class FatherScreen extends StatefulWidget {
  const FatherScreen({super.key});

  @override
  State<FatherScreen> createState() => _FatherScreenState();
}

class _FatherScreenState extends State<FatherScreen> {
  bool showForm = false;
  String userName = 'جاري التحميل...';
  String userRole = 'جاري التحميل...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await StorageHelper.getSavedUserData();
      setState(() {
        userName = userData.userName ?? 'زائر';
        userRole = userData.role ?? 'مستخدم';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        userName = 'زائر';
        userRole = 'مستخدم';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<FatherCubit>(),
      //create: (context) => GetIt.I<FatherCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Row(
            children: [
              // المحتوى الرئيسي (على اليسار)
              Expanded(
                child: Column(
                  children: [
                    const TopBar(title: "إضافة أب"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SearchIdentitySection(
                              type: 'father',
                              onSearchCompleted: (found) {
                                setState(() => showForm = found);
                              },
                            ),
                            const SizedBox(height: 20),
                            if (showForm)
                              Expanded(
                                child: BlocBuilder<FatherCubit, FatherState>(
                                  builder: (context, state) {
                                    if (state is FatherLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return const FatherFormSection();
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // الشريط الجانبي (على اليمين)
              SizedBox(
                width: 300, // عرض ثابت
                child: SideNav(
                  userName: userName,
                  userRole: userRole,
                  menuItems: MenuItemsHelper.getMenuItems(userRole),
                  onMenuItemTap: (routeName) {
                    Navigator.pushNamed(context, routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
