import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/presentation/father_form_section.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';

class FatherScreen extends StatefulWidget {
  const FatherScreen({super.key});

  @override
  State<FatherScreen> createState() => _FatherScreenState();
}

class _FatherScreenState extends State<FatherScreen> {
  bool showForm = false;
  late String userName = '';
  late String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userName =
        await StorageHelper.getData(SharedPrefKeys.userName, isSecure: true) ??
            'زائر';
    userRole =
        await StorageHelper.getData(SharedPrefKeys.userRole, isSecure: true);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di<PersonCubit>()),
        BlocProvider(create: (_) => di<FatherCubit>()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const TopBar(title: "إضافة أب"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildMainContent(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 300,
                child: SideNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: showForm
          ? FatherFormSection(key: UniqueKey())
          : SingleChildScrollView(
              key: UniqueKey(),
              child: Column(
                children: [
                  SearchIdentitySection(
                    type: 'father',
                    onSearchCompleted: (found) {
                      if (mounted) setState(() => showForm = found);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
