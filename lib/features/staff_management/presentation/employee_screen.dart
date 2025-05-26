import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/helpers/shared_pref__keys.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';
import 'package:new_project/features/staff_management/logic/employee.state.dart';
import 'package:new_project/features/staff_management/logic/employee_cubit.dart';
import 'package:new_project/features/staff_management/presentation/employee_form_section.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeCubit _EmployeeCubit = GetIt.I<EmployeeCubit>();
  final PersonCubit _personCubit = GetIt.I<PersonCubit>();

  bool showForm = false;
  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // _personCubit.getNationalitiesAndCities(PersonType.Employee);
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
    _EmployeeCubit.close();
    _personCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeCubit>(
          create: (_) {
            print("Creating EmployeeCubit from GetIt");
            return GetIt.I<EmployeeCubit>();
          },
        ),
        BlocProvider<PersonCubit>(
          create: (_) => GetIt.I<PersonCubit>(),
        ),
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
                    const TopBar(title: "إضافة موظف"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SearchIdentitySection(
                            type: 'employee',
                            onSearchCompleted: handleSearchResult,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocBuilder<EmployeeCubit, EmployeeState>(
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

      //_personCubit.getNationalitiesAndCities(PersonType.Employee);
    });
  }

  Widget _buildMainContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: showForm
          ? EmployeeFormSection(
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
