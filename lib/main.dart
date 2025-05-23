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
import 'package:new_project/Core/routing/app_router.dart';
import 'package:new_project/features/auth/logic/cubit/login_cubit.dart';
import 'package:new_project/features/auth/presentation/login_screen.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/mother_cubit.dart';
import 'package:new_project/features/guardian_management.dart/logic/guardian_cubit.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupPersonServiceLocatorInject();
  
  final isRegistered = GetIt.I.isRegistered<PersonCubit>();
    print('✅ PersonCubit Registered: $isRegistered');
    await setupFamilyServiceLocator();
  final isRegister = GetIt.I.isRegistered<FatherCubit>(); 
    print('✅ FatherCubit Registered: $isRegister');
  runApp(const AppBootstrapper());
}
       //? "username":"user_Ro5ofEk",
       //? "password":"4thSWXLXCU5pyXM"
       //?"identity_card_number": "2956023408534",

class AppBootstrapper extends StatelessWidget {
  const AppBootstrapper({super.key});
  Future<void> _initializeApp() async {
    try {
      await ScreenUtil.ensureScreenSize();
      await setupServiceLocator();
      await setupAuthServiceLocator(useMock: false);
     // await setupPersonServiceLocatorInject();
      //await setupFamilyServiceLocator();
      await setupGuardianServiceLocator();
      await initChildManagementDependencies();
      _verifyDependencies();
    } catch (e) {
      debugPrint('Error during initialization: $e');
      rethrow;
    }
  }

  void _verifyDependencies() {
    final checks = {
      'PersonCubit': GetIt.I.isRegistered<PersonCubit>(),
      'FatherCubit': GetIt.I.isRegistered<FatherCubit>(),
      'MotherCubit': GetIt.I.isRegistered<MotherCubit>(),
      'GuardianCubit': GetIt.I.isRegistered<GuardianCubit>(),
      'LoginCubit': GetIt.I.isRegistered<LoginCubit>(),
    };

  for (var entry in checks.entries) {
    if (!entry.value) {
      throw Exception('❌ Dependency of type ${entry.key} not registered!');
    } else {
      debugPrint('✅ ${entry.key} is registered');
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp(); // يتم عرض التطبيق فقط بعد التهيئة
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
  final di = GetIt.I;
  return [
    BlocProvider<LoginCubit>(create: (_) => di<LoginCubit>()),
    BlocProvider<PersonCubit>(create: (_) => di<PersonCubit>()),
    BlocProvider<FatherCubit>(create: (_) => di<FatherCubit>()),
    BlocProvider<MotherCubit>(create: (_) => di<MotherCubit>()),
    BlocProvider<GuardianCubit>(create: (_) => di<GuardianCubit>()),
  ];
}

Widget _getHomeScreen() {
  return const LoginScreen(); // أو FatherScreen للتجربة
}
