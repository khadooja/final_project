import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/auth/data/repos/login_repo.dart';
import 'package:new_project/features/auth/data/mock_login_repo.dart'; // إذا كنت تستخدمه
import 'package:new_project/features/auth/logic/cubit/login_cubit.dart';
import 'package:new_project/Core/di/get_it.dart'; // تأكد من أن هذا هو di الصحيح (GetIt.instance)

Future<void> setupAuthServiceLocator({bool useMock = false}) async {
  // تسجيل LoginRepo مع التحقق
  if (!di.isRegistered<LoginRepo>()) {
    di.registerLazySingleton<LoginRepo>(
      () => useMock ? MockLoginRepo() : LoginRepo(di<ApiServiceManual>()),
    );
  } else if (useMock) {
    // إذا كنت تريد استبدال التسجيل الحالي بنسخة mock إذا كان مسجلاً بالفعل
    // هذا اختياري ويعتمد على منطق useMock الخاص بك
    await di.unregister<LoginRepo>(); // قم بإلغاء التسجيل أولاً
    di.registerLazySingleton<LoginRepo>(() => MockLoginRepo());
    // قد تحتاج أيضًا إلى إلغاء تسجيل وإعادة تسجيل LoginCubit إذا تغير الـ repo
    if (di.isRegistered<LoginCubit>()) {
      await di.unregister<LoginCubit>();
    }
  }

  // تسجيل LoginCubit مع التحقق
  if (!di.isRegistered<LoginCubit>()) {
    di.registerFactory<LoginCubit>(
      () => LoginCubit(di<
          LoginRepo>()), // سيلتقط الـ MockLoginRepo إذا تم تسجيله أعلاه في حالة useMock
    );
  }
  // لا تحتاج إلى else if (useMock) هنا عادةً لـ Cubit،
  // لأنه سيتم إنشاؤه باستخدام الـ repo الجديد (mock أو حقيقي)
  // إلا إذا كان لديك منطق محدد لاستبدال الـ Cubit نفسه.

  print("✅ Auth Service Locator Initialized (LoginRepo, LoginCubit)");
}
