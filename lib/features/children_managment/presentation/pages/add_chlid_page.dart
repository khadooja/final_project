import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/children_managment/presentation/widget/addChildForm.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';

class AddChildScreen extends StatefulWidget {
  final int fatherId;
  final int motherId;

  const AddChildScreen({
    super.key,
    required this.fatherId,
    required this.motherId,
  });

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final PersonCubit _personCubit = GetIt.I<PersonCubit>();
  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // يمكنك تحميل البيانات الأولية هنا إذا لزم الأمر
    // _personCubit.getNationalitiesAndCities(PersonType.child);
  }

  Future<void> _loadUserData() async {
    userName = await StorageHelper.getData(
          SharedPrefKeys.userName,
          isSecure: true,
        ) ??
        'زائر';
    userRole = await StorageHelper.getData(
      SharedPrefKeys.userRole,
      isSecure: true,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _personCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _personCubit,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Row(
            children: [
              const SizedBox(width: 300, child: SideNav()),
              Expanded(
                child: Column(
                  children: [
                    const TopBar(title: "إضافة طفل"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AddChildForm(
                          fatherId: widget.fatherId,
                          motherId: widget.motherId,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}