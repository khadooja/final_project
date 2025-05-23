import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/family_management/presentation/father_form_section.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';

class FatherScreen extends StatefulWidget {
  const FatherScreen({super.key});

  @override
  State<FatherScreen> createState() => _FatherScreenState();
}

class _FatherScreenState extends State<FatherScreen> {
  final FatherCubit _fatherCubit = GetIt.I<FatherCubit>();
  final PersonCubit _personCubit = GetIt.I<PersonCubit>();

  bool showForm = false;
  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
   // _fatherCubit.loadDropdowns();
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
    _fatherCubit.close();
    _personCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _fatherCubit),
        BlocProvider.value(value: _personCubit),
      ],
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
                    const TopBar(title: "إضافة أب"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SearchIdentitySection(
                            type: 'father',
                            onSearchCompleted: handleSearchResult,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocBuilder<FatherCubit, FatherState>(
                          builder: (context, state) {
                            return _buildMainContent();
                          },
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

 SearchPersonResponse? _searchResult;

void handleSearchResult(SearchPersonResponse? person) {
  setState(() {
    _searchResult = person;
    showForm = true;
  });
}


 Widget _buildMainContent() {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: showForm
        ? FatherFormSection(
            key: const ValueKey('form'),
            searchResult: _searchResult,
          )
        : const Center(
            key: ValueKey("empty"),
            child: Text(
              "يرجى البحث برقم الهوية لإظهار البيانات",
              style: TextStyle(fontSize: 18),
            ),
          ),
  );
}


}
