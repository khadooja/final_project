import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:dio/dio.dart';
import 'package:new_project/Core/networking/dio_factory.dart';

// DataSources
import 'package:new_project/features/family_management/data/dataSources/fatherRemoteDataSource.dart';
import 'package:new_project/features/family_management/data/dataSources/fatherRemoteDataSourceImpl.dart';
import 'package:new_project/features/family_management/data/dataSources/motherRemoteDataSource.dart';
import 'package:new_project/features/family_management/data/dataSources/motherRemoteDataSourceImpl.dart';

// Repositories
import 'package:new_project/features/family_management/data/repo/fatherRepositoryImpl.dart';
import 'package:new_project/features/family_management/data/repo/motherRepositoryImpl.dart';

// Domain Repositories
import 'package:new_project/features/family_management/domain/repository/fatherRepository.dart';
import 'package:new_project/features/family_management/domain/repository/motherRepository.dart';

// UseCases
import 'package:new_project/features/family_management/domain/usecases/addFatherUseCase.dart';
import 'package:new_project/features/family_management/domain/usecases/updateFatherUsecase.dart';
import 'package:new_project/features/family_management/domain/usecases/addMotherUseCase.dart';
import 'package:new_project/features/family_management/domain/usecases/updateMotherUsecase.dart';

// Cubits
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

Future<void> setupFamilyServiceLocator() async {

  // ========== DATASOURCES ==========
  di.registerLazySingleton<FatherRemoteDataSource>(
    () => FatherRemoteDataSourceImpl(di<ApiServiceManual>()),
  );

  di.registerLazySingleton<MotherRemoteDataSource>(
    () => MotherRemoteDataSourceImpl(di<ApiServiceManual>()),
  );

  // ========== REPOSITORIES ==========
  di.registerLazySingleton<FatherRepository>(
    () => FatherRepositoryImpl(di<FatherRemoteDataSource>()),
  );

  di.registerLazySingleton<MotherRepository>(
    () => MotherRepositoryImpl(di<MotherRemoteDataSource>()),
  );

  // ========== USECASES ==========
  di.registerLazySingleton<AddFatherUseCase>(
    () => AddFatherUseCase(di<FatherRepository>()),
  );

  di.registerLazySingleton<UpdateFatherUseCase>(
    () => UpdateFatherUseCase(repository: di<FatherRepository>()),
  );

  di.registerLazySingleton<AddMotherUseCase>(
    () => AddMotherUseCase(di<MotherRepository>()),
  );

  di.registerLazySingleton<UpdateMotherUseCase>(
    () => UpdateMotherUseCase(repository: di<MotherRepository>()),
  );

  // ========== CUBITS ==========
  di.registerFactory<FatherCubit>(
    () => FatherCubit(
      di<FatherRepository>(),
      di<PersonRepository>(), // تأكد من تسجيل PersonRepository في مكان آخر
    ),
  );
}
