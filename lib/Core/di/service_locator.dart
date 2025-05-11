import 'package:dio/dio.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/dio_factory.dart';

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
}
