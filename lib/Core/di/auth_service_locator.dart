import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/auth/data/mock_login_repo.dart';
import 'package:new_project/features/auth/data/repos/login_repo.dart';
import 'package:new_project/features/auth/logic/cubit/login_cubit.dart';

/*Future<void> setupAuthServiceLocator() async {
  // ========== CORE ==========

  final sl = GetIt.instance;
  assert(sl.isRegistered<ApiServiceManual>(),
      'ApiServiceManual must be registered first!');
  // login
  sl.registerLazySingleton<LoginRepo>(() => LoginRepo(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
}*/
Future<void> setupAuthServiceLocator({bool useMock = false}) async {
  if (!di.isRegistered<ApiServiceManual>()) {
    throw Exception('ApiServiceManual must be registered first!');
  }

  if (useMock) {
    await di.reset();
  }

  if (!di.isRegistered<ApiServiceManual>()) {
    di.registerLazySingleton(() => ApiServiceManual(dio: di<Dio>()));
  }

  di.registerLazySingleton<LoginRepo>(
    () => useMock ? MockLoginRepo() : LoginRepo(di()),
  );

  di.registerFactory<LoginCubit>(
    () => LoginCubit(di<LoginRepo>()),
  );
}
