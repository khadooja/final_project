
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/auth/data/repos/login_repo.dart';
import 'package:new_project/features/auth/data/mock_login_repo.dart';
import 'package:new_project/features/auth/logic/cubit/login_cubit.dart';
import 'package:new_project/Core/di/get_it.dart';

Future<void> setupAuthServiceLocator({bool useMock = false}) async {
  di.registerLazySingleton<LoginRepo>(
    () => useMock ? MockLoginRepo() : LoginRepo(di<ApiServiceManual>()),
  );

  di.registerFactory<LoginCubit>(
    () => LoginCubit(di<LoginRepo>()),
  );
}
