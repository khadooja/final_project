import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/features/staff_management/logic/employee_cubit.dart';

import '../../features/auth/logic/cubit/login_cubit.dart';
import '../../features/personal_management/logic/personal_cubit.dart';
import '../../features/family_management/logic/father_cubit.dart';
import '../../features/family_management/logic/mother_cubit.dart';
import '../../features/guardian_management.dart/logic/guardian_cubit.dart';

List<BlocProvider> getBlocProviders() {
  final di = GetIt.I;
  return [
    BlocProvider<LoginCubit>(create: (_) => di<LoginCubit>(), lazy: false),
    BlocProvider<PersonCubit>(create: (_) => di<PersonCubit>()),
    BlocProvider<FatherCubit>(create: (_) => di<FatherCubit>()),
    BlocProvider<MotherCubit>(create: (_) => di<MotherCubit>()),
    BlocProvider<EmployeeCubit>(create: (_) => di<EmployeeCubit>()),
    //BlocProvider<GuardianCubit>(create: (_) => di<GuardianCubit>()),
  ];
}
