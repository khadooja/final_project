import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/auth_service_locator.dart';
import 'package:new_project/Core/di/child_service_locator.dart';
import 'package:new_project/Core/di/family_service_locator.dart';
import 'package:new_project/Core/di/service_locator.dart';
import 'package:new_project/Core/routing/app_router.dart';
import 'package:new_project/features/auth/logic/cubit/login_cubit.dart';
import 'package:new_project/features/auth/logic/cubit/login_state.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/mother_cubit.dart';
import 'package:new_project/features/guardian_management.dart/logic/guardian_cubit.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'Core/di/person_service_locator.dart';
import 'Core/di/guardian_service_locator.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/screens/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة ScreenUtil بحجم التصميم الأساسي
  await ScreenUtil.ensureScreenSize();
  print("object..................................................");
  await _initializeApp();
  print("App initialization completed..........................");
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    setupServiceLocator();
    print("Service locator setup completed.....................");
    print("Dio setup completed..................................");

    await setupAuthServiceLocator(useMock: true);

    print("Auth service locator setup completed.................");

    await setupPersonServiceLocatorInject();
    print("Person service locator setup completed...............");

    await setupFamilyServiceLocator();

    await setupGuardianServiceLocator();

    await initChildManagementDependencies();

    print("All service locators completed.......................");
  } catch (e, stack) {
    print("Error during app initialization: $e");
    print(stack);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: _getBlocProviders(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            home: child,
          ),
        );
      },
      child: _getHomeScreen(),
    );
  }
}

List<BlocProvider> _getBlocProviders() {
  return [
    BlocProvider<LoginCubit>(
      create: (_) => GetIt.I<LoginCubit>(),
    ),
    BlocProvider<FatherCubit>(create: (_) => GetIt.I<FatherCubit>()),
    BlocProvider<MotherCubit>(create: (_) => GetIt.I<MotherCubit>()),
    BlocProvider<PersonCubit>(create: (_) => GetIt.I<PersonCubit>()),
    BlocProvider<GuardianCubit>(create: (_) => GetIt.I<GuardianCubit>()),
  ];
}

Widget _getHomeScreen() {
  return Builder(
    builder: (context) {
      return BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is Success) {
            final role = state.role.toLowerCase();

            if (role == 'admin') {
              return const AdminDashboardScreen();
            } else if (role == 'staff') {
              return const AdminDashboardScreen();
            }
          }
          return const LoginScreen(); // افتراضيًا أو إذا فشل التسجيل
        },
      );
    },
  );
}
