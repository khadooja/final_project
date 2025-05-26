import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/get_it.dart';
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

  // ========== DataSources ==========
  di.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(di<ApiServiceManual>()),
  );

  // ========== Repository ==========
  di.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(di<PersonRemoteDataSource>()),
  );

  // ========== UseCases ==========
  di.registerLazySingleton<SearchPersonByIdUseCase>(
    () => SearchPersonByIdUseCase(di<PersonRepository>()),
  );

  di.registerLazySingleton<GetAreasByCityUseCase>(
    () => GetAreasByCityUseCase(di<PersonRepository>()),
  );

  di.registerLazySingleton<GetNationalitiesAndCitiesUseCase>(
    () => GetNationalitiesAndCitiesUseCase(di<PersonRepository>()),
  );

  di.registerLazySingleton<ToggleActivationPersonUseCase>(
    () => ToggleActivationPersonUseCase(di<PersonRepository>()),
  );

  // ========== Cubits ==========
  di.registerFactory<PersonCubit>(
    () => PersonCubit(di<PersonRepository>()),
  );

  debugPrint('✅ Person dependencies injected successfully');
}