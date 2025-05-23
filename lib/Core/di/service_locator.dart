import 'package:dio/dio.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/dio_factory.dart';
import 'package:new_project/features/HelthCenter/data/repository/health_center_repository.dart';
import 'package:new_project/features/HelthCenter/logic/cubit/health_center_cubit.dart';
import 'package:new_project/features/vaccination/dose/data/repos/dose_repo.dart';
import 'package:new_project/features/vaccination/dose/logic/cubit/dose_cubit.dart';
import 'package:new_project/features/vaccination/stage/data/repos.dart';
import 'package:new_project/features/vaccination/stage/logic/cubit/StageCubit.dart';
import 'package:new_project/features/vaccination/vaccine/data/vaccine_repository.dart';
import 'package:new_project/features/vaccination/vaccine/logic/vaccine_cubit.dart';

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
  if (!di.isRegistered<StageRepository>()) {
    di.registerLazySingleton<StageRepository>(
      () => StageRepository(api: di<ApiServiceManual>()),
    );
  }

  if (!di.isRegistered<Stagecubit>()) {
    di.registerFactory<Stagecubit>(
      () => Stagecubit(repository: di<StageRepository>()),
    );
  }
  if (!di.isRegistered<VaccineRepository>()) {
    di.registerLazySingleton<VaccineRepository>(
      () => VaccineRepository(api: di<ApiServiceManual>()),
    );
  }

  if (!di.isRegistered<VaccineCubit>()) {
    di.registerFactory<VaccineCubit>(
      () => VaccineCubit(repository: di<VaccineRepository>()),
    );
  }
  if (!di.isRegistered<HealthCenterRepository>()) {
    di.registerLazySingleton<HealthCenterRepository>(
      () => HealthCenterRepository(api: di<ApiServiceManual>()),
    );
  }

  if (!di.isRegistered<HealthCenterCubit>()) {
    di.registerFactory<HealthCenterCubit>(
      () => HealthCenterCubit(repository: di<HealthCenterRepository>()),
    );
  }
}
