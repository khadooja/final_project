import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/auth_service_locator.dart';
import 'package:new_project/Core/di/child_service_locator.dart';
import 'package:new_project/Core/di/family_service_locator.dart';
import 'package:new_project/Core/di/guardian_service_locator.dart';
import 'package:new_project/Core/di/person_service_locator.dart';
import 'package:new_project/Core/di/service_locator.dart';
import 'package:new_project/features/auth/presentation/login_screen.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/mother_cubit.dart';
import 'package:new_project/features/guardian_management.dart/logic/guardian_cubit.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';

import 'Core/routing/app_router.dart';
import 'features/auth/logic/cubit/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrapper());
}

class AppBootstrapper extends StatelessWidget {
  const AppBootstrapper({super.key});

  Future<void> _initializeApp() async {
    try {
      await ScreenUtil.ensureScreenSize();

      // الترتيب الأمثل لتهيئة DI
      await setupServiceLocator(); // التهيئة الأساسية أولاً
      await setupAuthServiceLocator(useMock: false);
      await setupPersonServiceLocatorInject();
      print('object setupPersonServiceLocatorInject');
      await setupFamilyServiceLocator();
      await setupGuardianServiceLocator();
      await initChildManagementDependencies();

      // التحقق من التهيئة
      _verifyDependencies();
    } catch (e) {
      debugPrint('Error during initialization: $e');
      rethrow;
    }
  }

  void _verifyDependencies() {

    final di = GetIt.I;
    final requiredDependencies = [
      'LoginCubit',
      'FatherCubit',
      'MotherCubit',
      'PersonCubit',
      'GuardianCubit'
    ];
        assert(di.isRegistered<PersonCubit>(), 'PersonCubit not registered!');
  assert(di.isRegistered<PersonRepository>(), 'PersonRepository not registered!');

    for (var dep in requiredDependencies) {
      if (!di.isRegistered(instanceName: dep)) {
        throw Exception('Dependency $dep not registered!');
      }
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
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('خطأ في التهيئة: ${snapshot.error}')),
            ),
          );
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          builder: (context, child) {
            return MultiBlocProvider(
              providers: _getBlocProviders(),
              child: child!,
            );
          },
          home: _getHomeScreen(),
        );
      },
    );
  }
}

List<BlocProvider> _getBlocProviders() {
  final di = GetIt.I;
  return [
    BlocProvider<LoginCubit>(
      create: (context) => di<LoginCubit>(),
      lazy: false, // يتم إنشاؤه فوراً
    ),
    BlocProvider<PersonCubit>(
      create: (context) => di<PersonCubit>(),
    ),
    BlocProvider<FatherCubit>(
      create: (context) => di<FatherCubit>(),
    ),
    BlocProvider<MotherCubit>(
      create: (context) => di<MotherCubit>(),
    ),
    BlocProvider<GuardianCubit>(
      create: (context) => di<GuardianCubit>(),
    ),
  ];
}

Widget _getHomeScreen() => const LoginScreen();
