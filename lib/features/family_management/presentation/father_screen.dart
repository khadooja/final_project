import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/sideNav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/di/get_it.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<FatherCubit>(),
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
              SizedBox(
                width: 300,
                child: SideNav(
                  userName: '',   
                  userRole: '',
                  menuItems: const [],     
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
}
