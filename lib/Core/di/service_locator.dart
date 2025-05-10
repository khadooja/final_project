import 'package:dio/dio.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';

Future<void> setupServiceLocator() async {
  if (!di.isRegistered<Dio>()) {
    di.registerSingleton<Dio>(Dio()
      ..options = BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));
  }

  if (!di.isRegistered<ApiServiceManual>()) {
    di.registerLazySingleton<ApiServiceManual>(
      () => ApiServiceManual(dio: di<Dio>()),
    );
  }
}
