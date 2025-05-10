import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_project/Core/commn_widgets/custom_button.dart';
import 'package:new_project/core/helpers/spacing.dart';
import 'package:new_project/features/auth/presentation/login_bloc_listener.dart';
import 'package:new_project/features/auth/presentation/username_and_password.dart';
import '../logic/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue.shade50,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              width: 0.4.sw,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.r,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('مرحبًا بعودتك',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const VerticalSpace(16),
                    const UsernameAndPassword(),
                    const VerticalSpace(24),
                    CustomButton(
                      text: 'دخول',
                      onPressed: () => _validateThenLogin(context),
                    ),
                    const VerticalSpace(24),
                    const LoginBlocListener(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateThenLogin(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    if (cubit.formKey.currentState!.validate()) {
      cubit.emitLoginStates();
    }
  }
}
