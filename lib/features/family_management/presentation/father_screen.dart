import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/family_management/data/model/father_model.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/presentation/father_form_section.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';

class FatherScreen extends StatefulWidget {
  const FatherScreen({super.key});

  @override
  State<FatherScreen> createState() => _FatherScreenState();
}

class _FatherScreenState extends State<FatherScreen> {
  bool showForm = false;
  String userName = '';
  String userRole = '';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Row(
          textDirection: TextDirection.rtl,
          children: [
            const SizedBox(width: 300, child: SideNav()),
            Expanded(
              child: Column(
                children: [
                  const TopBar(title: "إضافة أب"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: SearchIdentitySection(
                      type: 'father',
                      onSearchCompleted: (result) {
                        if (result == null) {
                          // لا يوجد شخص → عرض فورم فارغ
                          if (mounted) setState(() => showForm = true);
                        } else if (result.father != null) {
                          fillFormWithFather(result.father!);
                          if (mounted) setState(() => showForm = true);
                        } else if (result.person != null) {
                          fillFormWithPerson(result.person!);
                          if (mounted) setState(() => showForm = true);
                        }
                      },
                    ),
                  ),

                  // 👇 المحتوى الأساسي يتغير حسب حالة البحث
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildMainContent(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocProvider(
      create: (_) => GetIt.I<PersonCubit>(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showForm
            ? FatherFormSection(key: UniqueKey())
            : const Center(
                key: ValueKey("empty"),
                child: Text(
                  "يرجى البحث برقم الهوية لإظهار البيانات",
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }

  void fillFormWithFather(FatherModel father) {
    final cubit = context.read<FatherCubit>();
    cubit.fillFormWithFather(father);
  }

  void fillFormWithPerson(PersonModel person) {
    final cubit = context.read<FatherCubit>();
    cubit.fillFormWithPerson(person);
  }
}
