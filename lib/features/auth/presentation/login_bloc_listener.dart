import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/auth/logic/cubit/login_state.dart';
import '../logic/cubit/login_cubit.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_, role) {
            // تحقق من الدور واختار الصفحة المناسبة
            if (role == 'admin') {
              context.pushReplacementNamed(Routes.adminDashboard);
            } else if (role == 'user') {
              context.pushReplacementNamed(Routes.adminDashboard);
            } else {
              context.pushReplacementNamed(Routes.adminDashboard);
            }
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
