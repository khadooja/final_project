import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';
import 'package:new_project/features/staff_management/data/dataSource.dart/EmployeeRemoteDataSource.dart';
import 'package:new_project/features/staff_management/data/dataSource.dart/EmployeeReomteDataSource.dart';
import 'package:new_project/features/staff_management/data/repo/employeeRepositoryImpl.dart';
import 'package:new_project/features/staff_management/domain/repository/employeeRepository.dart';
import 'package:new_project/features/staff_management/domain/usecases/addEmployeeUseCase.dart';
import 'package:new_project/features/staff_management/domain/usecases/updateEmployeeUsecase.dart';
import 'package:new_project/features/staff_management/logic/employee_cubit.dart';

Future<void> setupEmployeeServiceLocator() async {
  // ========== DATASOURCES ==========
  di.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSourceImpl(di<ApiServiceManual>()),
  );

  // ========== REPOSITORIES ==========
  di.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(di<EmployeeRemoteDataSource>()),
  );

  // ========== USECASES ==========
  di.registerLazySingleton<AddEmployeeUseCase>(
    () => AddEmployeeUseCase(di<EmployeeRepository>()),
  );

  di.registerLazySingleton<UpdateEmployeeUseCase>(
    () => UpdateEmployeeUseCase(repository: di<EmployeeRepository>()),
  );

  // ========== CUBITS ==========
  di.registerFactory<EmployeeCubit>(
    () => EmployeeCubit(
      di<EmployeeRepository>(),
      di<PersonRepository>(), // تأكد من تسجيل PersonRepository في مكان آخر
    ),
  );
}
