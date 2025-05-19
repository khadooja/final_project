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
