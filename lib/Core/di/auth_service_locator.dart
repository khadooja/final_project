import 'package:dio/dio.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/dio_factory.dart';
import 'package:new_project/features/auth/data/mock_login_repo.dart';
import 'package:new_project/features/auth/data/repos/login_repo.dart';
import 'package:new_project/features/auth/logic/cubit/login_cubit.dart';

Future<void> setupAuthServiceLocator({bool useMock = false}) async {
  if (useMock) {
    await di.reset();

    // بعد reset: يجب إعادة تسجيل Dio و ApiServiceManual
    final dio = await DioFactory.getDio();
    di.registerSingleton<Dio>(dio);

    di.registerLazySingleton<ApiServiceManual>(
      () => ApiServiceManual(dio: dio),
    );
  } else {
    if (!di.isRegistered<ApiServiceManual>()) {
      throw Exception('ApiServiceManual must be registered first!');
    }
  }

  di.registerLazySingleton<LoginRepo>(
    () => useMock ? MockLoginRepo() : LoginRepo(di()),
  );
  di.registerFactory(() => LoginCubit(di()));
  di.registerFactory<LoginCubit>(
    () => LoginCubit(di<LoginRepo>()),
  );
}
