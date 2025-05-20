import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';

// DataSources
import 'package:new_project/features/family_management/data/dataSources/fatherRemoteDataSource.dart';
import 'package:new_project/features/family_management/data/dataSources/fatherRemoteDataSourceImpl.dart';
import 'package:new_project/features/family_management/data/dataSources/motherRemoteDataSource.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource_impl.dart';
import 'package:new_project/features/family_management/data/dataSources/motherRemoteDataSourceImpl.dart';
import 'package:new_project/features/personal_management/data/datasources/person_remote_datasource.dart';

// Repositories
import 'package:new_project/features/family_management/data/repo/fatherRepositoryImpl.dart';
import 'package:new_project/features/personal_management/data/repo/personRepositoryImpl.dart';
import 'package:new_project/features/family_management/data/repo/motherRepositoryImpl.dart';

// Domain Repositories
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';
import 'package:new_project/features/family_management/domain/repository/motherRepository.dart';

// UseCases
import 'package:new_project/features/family_management/domain/usecases/addFatherUseCase.dart';
import 'package:new_project/features/family_management/domain/usecases/updateFatherUsecase.dart';
import 'package:new_project/features/family_management/domain/usecases/addMotherUseCase.dart';
import 'package:new_project/features/family_management/domain/usecases/updateMotherUsecase.dart';
import 'package:new_project/features/personal_management/domain/usecases/getAreasByCityUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/getNationalitiesAndCitiesUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/search_personaUseCase.dart';
import 'package:new_project/features/personal_management/domain/usecases/toggleActivationUseCase.dart';

// Cubits
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/mother_cubit.dart';

Future<void> setupFamilyServiceLocator() async {
  if (!di.isRegistered<ApiServiceManual>()) {
    throw Exception('ApiServiceManual must be registered first!');
  }
  // ========== DATASOURCES ==========
  di.registerLazySingleton<FatherRemoteDataSource>(
    () => FatherRemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<FatherRemoteDataSource>(
    () => FatherRemoteDataSourceImpl(di<ApiServiceManual>()),
  );

  di.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<MotherRemoteDataSource>(
    () => MotherRemoteDataSourceImpl(di()),
  );

  // ========== REPOSITORIES ==========
  di.registerLazySingleton<FatherRepository>(() => FatherRepositoryImpl(di()));

  di.registerLazySingleton<FatherRepository>(
    () => FatherRepositoryImpl(di<FatherRemoteDataSource>()),
  );
  di.registerLazySingleton<MotherRepository>(() => MotherRepositoryImpl(di()));
  di.registerLazySingleton<PersonRepository>(() => PersonRepositoryImpl(di()));

  // ========== USECASES ==========
  di.registerLazySingleton<AddFatherUseCase>(
    () => AddFatherUseCase(di()),
  );
  di.registerLazySingleton<UpdateFatherUseCase>(
    () => UpdateFatherUseCase(repository: di()),
  );
  di.registerLazySingleton<AddMotherUseCase>(
    () => AddMotherUseCase(di()),
  );
  di.registerLazySingleton<UpdateMotherUseCase>(
    () => UpdateMotherUseCase(repository: di()),
  );
  di.registerLazySingleton<GetAreasByCityUseCase>(
    () => GetAreasByCityUseCase(di()),
  );
  di.registerLazySingleton<GetNationalitiesAndCitiesUseCase>(
    () => GetNationalitiesAndCitiesUseCase(di()),
  );
  di.registerLazySingleton<SearchPersonByIdUseCase>(
    () => SearchPersonByIdUseCase(di()),
  );
  di.registerLazySingleton<ToggleActivationPersonUseCase>(
    () => ToggleActivationPersonUseCase(di()),
  );

  // ========== CUBITS ==========
  di.registerFactory<FatherCubit>(
    () => FatherCubit(
      di<FatherRepository>(),
      di<PersonRepository>(),
    ),
  );
  di.registerFactory<FatherCubit>(() => FatherCubit(
        di(),
        di<PersonRepository>(),
      ));

  di.registerFactory<MotherCubit>(
    () => MotherCubit(di(), di()),
  );
}
