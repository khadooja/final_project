import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/family_management/logic/mother_cubit.dart';
import 'package:new_project/features/family_management/logic/mother_state.dart';
import 'package:new_project/features/family_management/presentation/mother_form_section.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';

class MotherScreen extends StatefulWidget {
  const MotherScreen({super.key});

  @override
  State<MotherScreen> createState() => _MotherScreenState();
}

class _MotherScreenState extends State<MotherScreen> {
  final MotherCubit _motherCubit = GetIt.I<MotherCubit>();
  final PersonCubit _personCubit = GetIt.I<PersonCubit>();

  bool showForm = false;
  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // _personCubit.getNationalitiesAndCities(PersonType.father);
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
    _motherCubit.close();
    _personCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _motherCubit),
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
                    const TopBar(title: "إضافة ام"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SearchIdentitySection(
                            type: 'mother',
                            onSearchCompleted: handleSearchResult,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocBuilder<MotherCubit, MotherState>(
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

      //_personCubit.getNationalitiesAndCities(PersonType.father);
    });
  }

  Widget _buildMainContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: showForm
          ? MotherFormSection(
              key: const ValueKey('form'),
              searchResult: _searchResult, // تمرير النتيجة هنا
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
