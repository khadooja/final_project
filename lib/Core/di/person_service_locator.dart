import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/dio_factory.dart';

// DataSources
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';

// Repositories
import 'package:new_project/features/personal_management/data/repo/personRepositoryImpl.dart';

// Domain
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

// UseCases
import 'package:new_project/features/personal_management/domain/usecases/getAreasByCityUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/getNationalitiesAndCitiesUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/search_personaUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/toggleActivationUseCase.dart';

// Cubits
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';

Future<void> setupPersonServiceLocatorInject() async {
  final getIt = GetIt.instance;

  // ========== Dio & ApiService ==========
  if (!getIt.isRegistered<Dio>()) {
    final dio = await DioFactory.getDio();
    getIt.registerSingleton<Dio>(dio);
  }

  if (!getIt.isRegistered<ApiServiceManual>()) {
    getIt.registerLazySingleton<ApiServiceManual>(
      () => ApiServiceManual(dio: getIt<Dio>()),
    );
  }

  // ========== DataSources ==========
  getIt.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(getIt<ApiServiceManual>()),
  );

  // ========== Repository ==========
  getIt.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(getIt<PersonRemoteDataSource>()),
  );

  // ========== UseCases ==========
  getIt.registerLazySingleton<SearchPersonByIdUseCase>(
    () => SearchPersonByIdUseCase(getIt<PersonRepository>()),
  );

  getIt.registerLazySingleton<GetAreasByCityUseCase>(
    () => GetAreasByCityUseCase(getIt<PersonRepository>()),
  );

  getIt.registerLazySingleton<GetNationalitiesAndCitiesUseCase>(
    () => GetNationalitiesAndCitiesUseCase(getIt<PersonRepository>()),
  );

  getIt.registerLazySingleton<ToggleActivationPersonUseCase>(
    () => ToggleActivationPersonUseCase(getIt<PersonRepository>()),
  );

  // ========== Cubits ==========
  getIt.registerFactory<PersonCubit>(
    () => PersonCubit(getIt<PersonRepository>()),
  );

  debugPrint('✅ Person dependencies injected successfully');
}