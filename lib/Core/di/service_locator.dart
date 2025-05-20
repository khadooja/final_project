import 'package:dio/dio.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/dio_factory.dart';
import 'package:new_project/features/vaccination/dose/data/repos/dose_repo.dart';
import 'package:new_project/features/vaccination/dose/logic/cubit/dose_cubit.dart';

Future<void> setupServiceLocator() async {
  if (!di.isRegistered<Dio>()) {
    final dio = await DioFactory.getDio();
    di.registerSingleton<Dio>(dio);
  }

  if (!di.isRegistered<ApiServiceManual>()) {
    di.registerLazySingleton<ApiServiceManual>(
      () => ApiServiceManual(dio: di<Dio>()),
    );
  }

  if (!di.isRegistered<DoseRepository>()) {
    di.registerLazySingleton<DoseRepository>(
      () => DoseRepository(api: di<ApiServiceManual>()),
    );
  }

  if (!di.isRegistered<DoseCubit>()) {
    di.registerFactory<DoseCubit>(
      () => DoseCubit(repository: di<DoseRepository>()),
    );
  }
}
