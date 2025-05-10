import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/di/service_locator.dart';
import 'package:new_project/Core/networking/api_services.dart';
// DataSources
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';
// Repositories
import 'package:new_project/features/personal_management/data/repo/personRepositoryImpl.dart';
// Domain Repositories
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';
// UseCases
import 'package:new_project/features/personal_management/domain/usecases/getAreasByCityUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/getNationalitiesAndCitiesUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/search_personaUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/toggleActivationUseCase.dart';
// Cubits
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';

// ========== CORE ==========
Future<void> setupPersonServiceLocatorInject() async {
  if (!di.isRegistered<ApiServiceManual>()) {
    throw Exception('ApiServiceManual must be registered first!');
  }
  // ========== DATASOURCES ==========
  di.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(di<ApiServiceManual>()),
  );

  // ========== REPOSITORY ==========
  di.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(di()),
  );

  // ========== USE CASES ==========
  di.registerLazySingleton<SearchPersonByIdUseCase>(
    () => SearchPersonByIdUseCase(di()),
  );
  di.registerLazySingleton<GetAreasByCityUseCase>(
    () => GetAreasByCityUseCase(di()),
  );
  di.registerLazySingleton<GetNationalitiesAndCitiesUseCase>(
    () => GetNationalitiesAndCitiesUseCase(di()),
  );
  di.registerLazySingleton<ToggleActivationPersonUseCase>(
    () => ToggleActivationPersonUseCase(di()),
  );

  // ========== CUBITS ==========
  di.registerFactory<PersonCubit>(
    () => PersonCubit(di()),
  );
}
