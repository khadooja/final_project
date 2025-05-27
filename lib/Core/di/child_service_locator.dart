import 'package:get_it/get_it.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_data_source.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/data/repositories/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/children_managment/domain/usecase/add_child.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_child_details_usecase.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_children_usecase.dart';
import 'package:new_project/features/children_managment/domain/usecase/search_parent_id.dart';
import 'package:new_project/features/children_managment/domain/usecase/update_child.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_cubit.dart';

Future<void> initChildManagementDependencies() async {
  final getch = GetIt.instance;
  if (!getch.isRegistered<ApiServiceManual>()) {
    // هذا مجرد مثال، يجب أن يتم تسجيل ApiServiceManual بشكل صحيح في مكانه المخصص.
    // إذا لم يكن مسجلاً، فسيحدث خطأ عند محاولة getch<ApiServiceManual>() أدناه.
    print("تحذير: ApiServiceManual غير مسجل! قد تحدث أخطاء.");
    // throw Exception("ApiServiceManual not registered. Ensure it's set up in a prior service locator.");
  }

  // // Data Sources
  // if (!getch.isRegistered<ChildRemoteDataSource>()) {
  //   getch.registerLazySingleton<ChildRemoteDataSource>(
  //     () => ChildRemoteDataSourceImpl(getch()),
  //   );
  // }
// Data Sources
  if (!getch.isRegistered<ChildRemoteDataSource>()) {
    getch.registerLazySingleton<ChildRemoteDataSource>(
      // توضيح الاعتمادية
      () => ChildRemoteDataSourceImpl(getch<ApiServiceManual>()), // <--- مهم
    );
  }
  // Cubit
  // getch.registerFactory(() => ChildCubit(getch(), getch(), getch()));
// Cubit
  if (!getch.isRegistered<ChildCubit>()) {
    // <--- كان لديك تسجيل مكرر لـ Cubit، تم حذف واحد
    getch.registerFactory<ChildCubit>(() => ChildCubit(
          getch<ChildRepository>(),
          getch<GetChildrenUseCase>(),
          getch<GetChildDetailsUseCase>(),
        ));
  }
  // // Repository
  // if (!getch.isRegistered<ChildRepository>()) {
  //   // Repository
  //   getch.registerLazySingleton<ChildRepository>(
  //     () => ChildRepositoryImpl(getch()),
  //   );
  // }

  // Repository
  if (!getch.isRegistered<ChildRepository>()) {
    getch.registerLazySingleton<ChildRepository>(
      // توضيح الاعتمادية
      () => ChildRepositoryImpl(getch<ChildRemoteDataSource>()), // <--- مهم
    );
  }

  // Use Cases
  // if (!getch.isRegistered<AddChildUseCase>()) {
  //   getch.registerLazySingleton(() => AddChildUseCase(getch()));
  // }
  // if (!getch.isRegistered<UpdateChildUseCase>()) {
  //   getch.registerLazySingleton(() => UpdateChildUseCase(getch()));
  // }
  // if (!getch.isRegistered<SearchParentIdUseCase>()) {
  //   // Use Cases
  //   getch.registerLazySingleton(() => SearchParentIdUseCase(getch()));
  // }
  // // تسجيل الـ Use Cases المفقودة
  // if (!getch.isRegistered<GetChildrenUseCase>()) {
  //   getch.registerLazySingleton<GetChildrenUseCase>(
  //     () => GetChildrenUseCase(getch<ChildRepository>()),
  //   );
  // }
  // if (!getch.isRegistered<GetChildDetailsUseCase>()) {
  //   getch.registerLazySingleton<GetChildDetailsUseCase>(
  //     () => GetChildDetailsUseCase(getch<ChildRepository>()),
  //   );
  // }

// Use Cases
  if (!getch.isRegistered<AddChildUseCase>()) {
    getch.registerLazySingleton<AddChildUseCase>(
      () => AddChildUseCase(getch<ChildRepository>()), // <--- مهم
    );
  }

  if (!getch.isRegistered<UpdateChildUseCase>()) {
    getch.registerLazySingleton<UpdateChildUseCase>(
      () => UpdateChildUseCase(getch()), // <--- مهم
    );
  }

  if (!getch.isRegistered<SearchParentIdUseCase>()) {
    getch.registerLazySingleton<SearchParentIdUseCase>(
      () => SearchParentIdUseCase(getch()), // <--- مهم
    );
  }
  if (!getch.isRegistered<GetChildrenUseCase>()) {
    getch.registerLazySingleton<GetChildrenUseCase>(
      () => GetChildrenUseCase(getch<ChildRepository>()),
    );
  }
  if (!getch.isRegistered<GetChildDetailsUseCase>()) {
    getch.registerLazySingleton<GetChildDetailsUseCase>(
      () => GetChildDetailsUseCase(getch<ChildRepository>()),
    );
  }

  // Cubit
  // if (!getch.isRegistered<ChildCubit>()) {
  //   getch.registerFactory<ChildCubit>(() => ChildCubit(
  //         // تمرير الاعتماديات بالترتيب والنوع الصحيحين كما هو محدد في مُنشئ ChildCubit
  //         getch<ChildRepository>(), // المعامل الأول
  //         getch<GetChildrenUseCase>(), // المعامل الثاني
  //         getch<GetChildDetailsUseCase>(), // المعامل الثالث
  //         // إذا كان ChildCubit يتوقع AddChildUseCase كمعامل رابع (كمثال):
  //         // getch<AddChildUseCase>(),
  //       ));
  // }
}
