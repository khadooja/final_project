import 'package:get_it/get_it.dart';

// DataSources
import 'package:new_project/features/guardian_management.dart/data/dataSources/child_guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/child_guardian_remote_data_source_impl.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/guardian_remote_data_source.dart';
import 'package:new_project/features/guardian_management.dart/data/dataSources/guardian_remote_data_source_impl.dart';

// Repositories
import 'package:new_project/features/guardian_management.dart/data/repo/childGuardianRepositoryImpl.dart';
import 'package:new_project/features/guardian_management.dart/data/repo/guardianRepositoryImpl.dart';

// Domain Repositories
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/guardian_repository.dart';

// UseCases
import 'package:new_project/features/guardian_management.dart/domain/usecase/guardian_usecases/addGuardianUseCase.dart';
import 'package:new_project/features/guardian_management.dart/domain/usecase/guardian_usecases/updateGuardianUseCase.dart';

// Cubits
import 'package:new_project/features/guardian_management.dart/logic/ChildGuardianCubit.dart';
import 'package:new_project/features/guardian_management.dart/logic/guardian_cubit.dart';

// ========== CORE ==========
Future<void> setupGuardianServiceLocator() async {
  final getFa = GetIt.instance;

  // ========== DATASOURCES ==========
  getFa.registerLazySingleton<ChildGuardianRemoteDataSource>(
    () => ChildGuardianRemoteDataSourceImpl(getFa()),
  );
  getFa.registerLazySingleton<GuardianRemoteDataSource>(
    () => GuardianRemoteDataSourceImpl(getFa()),
  );

  // ========== REPOSITORIES ==========
  getFa.registerLazySingleton<ChildGuardianRepository>(
      () => ChildGuardianRepositoryImpl(getFa()));
  getFa.registerLazySingleton<GuardianRepository>(
    () => GuardianRepositoryImpl(getFa()),
  );

  // ========== USECASES ==========
  getFa.registerLazySingleton<AddGuardianUseCase>(
    () => AddGuardianUseCase(getFa()),
  );
  getFa.registerLazySingleton<UpdateGuardianUseCase>(
    () => UpdateGuardianUseCase(repository: getFa()),
  );

  // ========== CUBITS ==========
  getFa.registerFactory<GuardianCubit>(
    () => GuardianCubit(getFa(), getFa(), getFa()),
  );
  getFa.registerFactory<ChildGuardianCubit>(
    () => ChildGuardianCubit(getFa()),
  );
}
