import 'package:dio/dio.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/Core/networking/dio_factory.dart';

Future<void> setupServiceLocator() async {
  // تهيئة Dio باستخدام DioFactory
  if (!di.isRegistered<Dio>()) {
    final dio = await DioFactory.getDio(); // هنا يتم استدعاء addDioHeaders()
    di.registerSingleton<Dio>(dio); // تسجيل نفس النسخة المعدة مسبقًا
  }
  if (!di.isRegistered<ApiServiceManual>()) {
    di.registerLazySingleton<ApiServiceManual>(
      () => ApiServiceManual(dio: di<Dio>()),
    );
  }
}
