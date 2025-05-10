/*import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:new_project/features/staff_management/application/bloc/location_event.dart';
import 'package:new_project/features/staff_management/data/datasources/fakeStaffRemoteDataSource.dart';
import 'package:new_project/features/staff_management/data/datasources/fakelocationRemoteDataSource.dart';
import 'package:new_project/features/staff_management/data/repositories/;ocation_repository_iml.dart';
import 'package:new_project/features/staff_management/data/repositories/fakelocationrepo.dart';
import 'package:new_project/features/staff_management/data/repositories/fakestaffrepo.dart';
import 'package:new_project/features/staff_management/domain/repositories/;ocation_repository.dart';
import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:new_project/features/staff_management/data/datasources/staff_remote_data_source.dart';
import 'package:new_project/features/staff_management/data/datasources/location_remote_data_source.dart';
import 'package:new_project/features/staff_management/data/repositories/staff_repository_impl.dart';
import 'package:new_project/features/staff_management/domain/usecases/add_employee.dart';
import 'package:new_project/features/staff_management/domain/usecases/check_person_existence.dart';
import 'package:new_project/features/staff_management/domain/usecases/update_employee.dart';
import 'package:new_project/features/staff_management/domain/usecases/deactivate_employee.dart';
import 'package:new_project/features/staff_management/domain/usecases/get_areas_by_city.dart';
import 'package:new_project/features/staff_management/domain/usecases/get_streets_by_area.dart';
import 'package:new_project/features/staff_management/application/bloc/admin_bloc.dart';
import 'package:new_project/features/staff_management/application/bloc/location_bloc.dart';

final sl = GetIt.instance;

Future<void> initStaff(Box cacheBox, {required bool useMock}) async {
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() => Dio());
  }

  // تهيئة Hive
  Hive.init('path_to_hive_directory');
  final cacheBox = await Hive.openBox('app_cache');

  if (!sl.isRegistered<Box>()) {
    sl.registerLazySingleton<Box>(() => cacheBox);
  }

  if (useMock) {
    print("MockAdminRemoteDataSource.................");
    // تسجيل MockAdminRemoteDataSource في حالة استخدام البيانات الوهمية
    sl.registerLazySingleton<AdminRepository>(() {
      return MockAdminRemoteDataSource(
        remoteDataSource: FakeAdminRemoteDataSource(),
      );
    });

    sl.registerLazySingleton<LocationRepository>(() {
      return MockLocationRemoteDataSource(
          remoteDataSource: FakeLocationRemoteDataSource());
    });
  } else {
    print("RealAdminRemoteDataSource.................");
    // استخدم API حقيقي
    sl.registerLazySingleton<AdminRemoteDataSource>(() =>
        AdminRemoteDataSource(dio: sl(), baseUrl: "https://api.example.com"));
    sl.registerLazySingleton<LocationRemoteDataSource>(() =>
        LocationRemoteDataSource(
            dio: sl(), baseUrl: "https://api.example.com", cacheBox: sl()));
  }

  // تسجيل الـ Repositories
  if (!sl.isRegistered<AdminRepository>()) {
    sl.registerLazySingleton<AdminRepository>(
        () => AdminRepositoryImpl(remoteDataSource: sl()));
  }

  if (!sl.isRegistered<LocationRepository>()) {
    sl.registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(locationService: sl()));
  }

  // تسجيل الـ Use Cases
  if (!sl.isRegistered<AddEmployee>()) {
    sl.registerLazySingleton(() => AddEmployee(repository: sl()));
  }

  if (!sl.isRegistered<CheckPersonExistence>()) {
    sl.registerLazySingleton(() => CheckPersonExistence(repository: sl()));
  }

  if (!sl.isRegistered<UpdateEmployee>()) {
    sl.registerLazySingleton(() => UpdateEmployee(adminRemoteDataSource: sl()));
  }

  if (!sl.isRegistered<DeactivateEmployee>()) {
    sl.registerLazySingleton(() => DeactivateEmployee(sl<AdminRepository>()));
  }

  if (!sl.isRegistered<FetchAllLocations>()) {
    sl.registerLazySingleton(() => FetchAllLocations(sl()));
  }

  if (!sl.isRegistered<GetAreasByCity>()) {
    sl.registerLazySingleton(() => GetAreasByCity(sl()));
  }

  if (!sl.isRegistered<GetStreetsByArea>()) {
    sl.registerLazySingleton(() => GetStreetsByArea(sl()));
  }

  // تسجيل الـ Blocs
  if (!sl.isRegistered<AdminBloc>()) {
    sl.registerFactory(() => AdminBloc(
          repository: sl(),
          checkPersonExistence: sl(),
          addEmployee: sl(),
        ));
  }

  if (!sl.isRegistered<LocationBloc>()) {
    sl.registerFactory(() => LocationBloc(
          repository: sl(),
          getStreetsByArea: sl(),
          getAreasByCity: sl(),
          fetchAllLocations: sl(),
        ));
  }
}
*/