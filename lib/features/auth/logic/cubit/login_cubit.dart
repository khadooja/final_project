import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/dio_factory.dart';
import 'package:new_project/features/auth/data/mock_login_repo.dart';
import 'package:new_project/features/auth/data/model/login_request_body.dart';
import 'package:new_project/features/auth/data/repos/login_repo.dart';
import 'package:new_project/features/auth/logic/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  bool isObscureText = true;

  LoginCubit(this._loginRepo) : super(const LoginState.initial()) {
    _initMockLogin();
  }

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _initMockLogin() async {
    if (_loginRepo is MockLoginRepo) {
      await Future.delayed(Duration.zero); // يضمن التنفيذ بعد البناء
      //autoLoginForMock();
    }
  }

  void emitLoginStates() async {
    emit(const LoginState.loading());
    debugPrint('🚀 بدء عملية تسجيل الدخول...');

    if (!formKey.currentState!.validate()) {
      emit(const LoginState.error('يرجى تعبئة الحقول'));
      return;
    }
    debugPrint(
        'بيانات المستخدم: username: ${usernameController.text.trim()}, password: ${passwordController.text.trim()}');

    final response = await _loginRepo.login(
      LoginRequestBody(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    debugPrint('📦 الريسبونس الراجع من loginRepo: ${response.toString()}');

    response.when(
      success: (loginResponse) async {
        debugPrint('✅ تسجيل الدخول ناجح: ${loginResponse.toString()}');

        if (loginResponse.token == null) {
          emit(const LoginState.error('Token is missing in response'));
          return;
        }

        // حفظ بيانات المستخدم
        await StorageHelper.saveUserData(loginResponse);

        // تحديث الهيدر في Dio
        final token = "${loginResponse.tokenType} ${loginResponse.token}";
        final centerId = (loginResponse.centerId ?? '').toString();
        DioFactory.setTokenIntoHeaderAfterLogin(token, centerId);

        emit(LoginState.success(loginResponse, loginResponse.role ?? ''));
      },
      failure: (error) {
        final errorMessage = _extractErrorMessage(error);
        debugPrint('❌ فشل تسجيل الدخول: $errorMessage');
        emit(LoginState.error(errorMessage));
      },
    );
  }

  String _extractErrorMessage(dynamic error) {
    if (error is ErrorHandler) {
      return error.message.isNotEmpty ? error.message : 'فشل تسجيل الدخول';
    } else if (error is DioException) {
      if (error.response != null && error.response!.data != null) {
        final data = error.response!.data;
        // إذا كانت الاستجابة تحتوي على رسالة مفصلة
        return data['message'] ?? 'خطأ في الاتصال بالسيرفر';
      } else {
        return 'خطأ في الاتصال بالسيرفر';
      }
    } else {
      return error.toString().contains('Exception')
          ? 'حدث خطأ غير متوقع'
          : error.toString();
    }
  }

  void togglePasswordVisibility() {
    isObscureText = !isObscureText;
    emit(PasswordVisibilityChanged());
    debugPrint('Password visibility changed to: $isObscureText');
  }
}


















/*import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/Core/networking/api_error_handler.dart';
import 'package:new_project/Core/networking/dio_factory.dart';
import 'package:new_project/features/auth/data/mock_login_repo.dart';
import 'package:new_project/features/auth/data/model/login_request_body.dart';
import 'package:new_project/features/auth/data/repos/login_repo.dart';
import 'package:new_project/features/auth/logic/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  bool isObscureText = true;
  LoginCubit(this._loginRepo) : super(const LoginState.initial()) {
    _initMockLogin();
  }

  Future<void> _initMockLogin() async {
    if (_loginRepo is MockLoginRepo) {
      await Future.delayed(Duration.zero); // يضمن التنفيذ بعد البناء
      //autoLoginForMock();
    }
  }

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void emitLoginStates() async {
    emit(const LoginState.loading());
    debugPrint('بدء عملية تسجيل الدخول...');
    if (!formKey.currentState!.validate()) {
      emit(const LoginState.error('Please fill all fields'));
      return;
    }

    try {
      final response = await _loginRepo.login(
        LoginRequestBody(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      response.when(
        success: (loginResponse) async {
          debugPrint('Login success: ${loginResponse.toString()}');

          if (loginResponse.token == null) {
            emit(const LoginState.error('Token is missing in response'));
            return;
          }
          await StorageHelper.saveUserData(loginResponse);
          // await saveUserToken(loginResponse.token!);
          // await saveUserRole(loginResponse.role ?? '');
          //await saveUserName(loginResponse.userName ?? '');
          //await saveCenterIdIfNotExists(loginResponse.centerId ?? '');

          emit(LoginState.success(loginResponse, loginResponse.role ?? ''));
        },
        failure: (error) {
          final errorMessage = _extractErrorMessage(error);
          debugPrint('فشل تسجيل الدخول: $errorMessage');
          emit(LoginState.error(errorMessage));
        },
      );
    } catch (e) {
      debugPrint('خطأ غير متوقع: ${e.toString()}');
      emit(const LoginState.error('حدث خطأ تقني، يرجى المحاولة لاحقاً'));
    }
  }

  String _extractErrorMessage(dynamic error) {
    if (error is ErrorHandler) {
      return error.message.isNotEmpty ? error.message : 'فشل تسجيل الدخول';
    } else if (error is DioException) {
      return error.response?.data?['message'] ?? 'خطأ في الاتصال بالسيرفر';
    } else {
      return error.toString().contains('Exception')
          ? 'حدث خطأ غير متوقع'
          : error.toString();
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is ErrorHandler) {
      return error.message;
    } else if (error is DioException) {
      return error.response?.data?['message'] ??
          error.message ??
          'Network error';
    } else {
      return error.toString();
    }
  }

  void togglePasswordVisibility() {
    isObscureText = !isObscureText;
    emit(PasswordVisibilityChanged());
    debugPrint('Password visibility changed to: $isObscureText');
  }

  // دوال حفظ البيانات في SharedPreferences
  Future<void> saveUserToken(String token) async {
    debugPrint('Saving token: $token');
    if (token.isEmpty) {
      throw Exception('Token is empty');
    }

    await FlutterSecureStorage().write(
      key: SharedPrefKeys.userToken,
      value: 'Bearer $token',
    );

    final savedToken =
        await FlutterSecureStorage().read(key: SharedPrefKeys.userToken);
    debugPrint('Token saved successfully: $savedToken');

    final centerId = await StorageHelper.getString(SharedPrefKeys.centerId);
    DioFactory.setTokenIntoHeaderAfterLogin('Bearer $token', centerId ?? '');
  }

  Future<void> saveUserRole(String role) async {
    await StorageHelper.setSecuredString(SharedPrefKeys.userRole, role);
  }

  Future<void> saveUserName(String name) async {
    await StorageHelper.setSecuredString(SharedPrefKeys.userName, name);
  }

  Future<void> saveCenterIdIfNotExists(String newCenterId) async {
    final savedCenterId =
        await StorageHelper.getString(SharedPrefKeys.centerId);
    if (savedCenterId == null) {
      await StorageHelper.setSecuredString(
          SharedPrefKeys.centerId, newCenterId);
    }
  }

  Future<void> saveCenterId(String centerId) async {
    await StorageHelper.setSecuredString(SharedPrefKeys.centerId, centerId);
  }

  // تسجيل دخول تلقائي في حالة mock repo
  void autoLoginForMock() async {
    final response = await _loginRepo.login(
      LoginRequestBody(username: 'koko', password: '123'),
    );

    response.when(
      success: (loginResponse) async {
        final token = loginResponse.token ?? '';
        if (token.isNotEmpty) {
          await saveUserToken(token);
          await saveUserRole(loginResponse.role ?? '');
          await saveUserName(loginResponse.userName ?? '');
          await saveCenterIdIfNotExists(loginResponse.centerId ?? '');

          debugPrint('Token: ${loginResponse.token}');
          debugPrint('UserName: ${loginResponse.userName}');
          debugPrint('Role: ${loginResponse.role}');
          debugPrint('CenterId: ${loginResponse.centerId}');

          emit(LoginState.success(loginResponse, loginResponse.role ?? ''));
        } else {
          emit(const LoginState.error('Token is empty'));
        }
      },
      failure: (error) {
        emit(const LoginState.error('Auto login failed'));
      },
    );
  }
}*/
