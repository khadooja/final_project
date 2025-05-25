import 'package:get_it/get_it.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_data_source.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/data/repositories/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/children_managment/domain/usecase/add_child.dart';
import 'package:new_project/features/children_managment/domain/usecase/search_parent_id.dart';
import 'package:new_project/features/children_managment/domain/usecase/update_child.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_cubit.dart';

Future<void> initChildManagementDependencies() async {
  final getch = GetIt.instance;

  // Data Sources
  getch.registerLazySingleton<ChildRemoteDataSource>(
    () => ChildRemoteDataSourceImpl(getch()),
  );

  getch.registerLazySingleton<ChildRemoteDataSource>(
    () => ChildRemoteDataSourceImpl(getch()),
  );

  // Repository
  getch.registerLazySingleton<ChildRepository>(
    () => ChildRepositoryImpl(getch()),
  );

  // Use Cases
  getch.registerLazySingleton(() => AddChildUseCase(getch()));
  getch.registerLazySingleton(() => UpdateChildUseCase(getch()));
  getch.registerLazySingleton(() => SearchParentIdUseCase(getch()));

  // Cubit
  getch.registerFactory(() => ChildCubit(getch(), getch(), getch()));
}
