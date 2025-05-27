import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/employee_service_locator.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/staff_management/logic/employee_cubit.dart';

import 'Core/di/auth_service_locator.dart';
import 'Core/di/child_service_locator.dart';
import 'Core/di/family_service_locator.dart';
import 'Core/di/person_service_locator.dart';
import 'Core/di/service_locator.dart';
import 'Core/helpers/shared_pref__keys.dart';
import 'Core/helpers/shared_pref_helper.dart';
import 'Core/routing/app_router.dart';

import 'features/auth/logic/cubit/login_cubit.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/family_management/logic/father_cubit.dart';
import 'features/family_management/logic/mother_cubit.dart';
import 'features/personal_management/logic/personal_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initAppDependencies();

  final centerId = await StorageHelper.getString(SharedPrefKeys.centerId);
  final showLogin = centerId == null || centerId.isEmpty;

  runApp(MyMainApp(showLogin: showLogin));
}

Future<void> _initAppDependencies() async {
  await StorageHelper.init();
  await ScreenUtil.ensureScreenSize();

  await setupNetworkModule();
  await setupAuthServiceLocator();
  await setupPersonServiceLocatorInject();
  await setupFamilyServiceLocator();
  await setupEmployeeServiceLocator();
  await initChildManagementDependencies();

  debugPrint('✅ Dependencies initialized');
}

class MyMainApp extends StatelessWidget {
  final bool showLogin;

  const MyMainApp({super.key, required this.showLogin});

  @override
  Widget build(BuildContext context) {
    final di = GetIt.I;

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<LoginCubit>(create: (_) => di<LoginCubit>()),
            BlocProvider<PersonCubit>(create: (_) => di<PersonCubit>()),
            BlocProvider<FatherCubit>(create: (_) => di<FatherCubit>()),
            BlocProvider<MotherCubit>(create: (_) => di<MotherCubit>()),
            BlocProvider<EmployeeCubit>(create: (_) => di<EmployeeCubit>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Route ${settings.name} not found')),
              ),
            ),
            home: showLogin ? const LoginScreen() : const AppBootstrapper(),
          ),
        );
      },
    );
  }
}

class AppBootstrapper extends StatelessWidget {
  const AppBootstrapper({super.key});

  Future<void> _initializeApp() async {
    try {
      await ScreenUtil.ensureScreenSize();
      await initChildManagementDependencies();
      _verifyDependencies();
    } catch (e) {
      debugPrint('❌ Error during initialization: $e');
      rethrow;
    }
  }

  void _verifyDependencies() {
    final checks = {
      'LoginCubit': GetIt.I.isRegistered<LoginCubit>(),
      'PersonCubit': GetIt.I.isRegistered<PersonCubit>(),
      'FatherCubit': GetIt.I.isRegistered<FatherCubit>(),
      'MotherCubit': GetIt.I.isRegistered<MotherCubit>(),
      'EmployeeCubit': GetIt.I.isRegistered<EmployeeCubit>(),
    };

    for (var entry in checks.entries) {
      if (!entry.value) {
        throw Exception('❌ ${entry.key} not registered!');
      }
      debugPrint('✅ ${entry.key} is registered');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('خطأ في التهيئة: ${snapshot.error}')),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // فقط واجهة التطبيق بعد التهيئة، لا حاجة لـ MaterialApp هنا
    return Center(child: Text('🎉 تم تحميل التطبيق بنجاح'));
  }
}

List<BlocProvider> _getBlocProviders() {
  final di = GetIt.I;
  return [
    BlocProvider<LoginCubit>(create: (_) => di<LoginCubit>()),
    BlocProvider<PersonCubit>(create: (_) => di<PersonCubit>()),
    BlocProvider<FatherCubit>(create: (_) => di<FatherCubit>()),
    BlocProvider<MotherCubit>(create: (_) => di<MotherCubit>()),
    BlocProvider<EmployeeCubit>(create: (_) => di<EmployeeCubit>()),
  ];
}

Widget _getHomeScreen() {
  return const LoginScreen();
}
