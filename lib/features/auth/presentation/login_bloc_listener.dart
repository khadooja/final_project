import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/auth/logic/cubit/login_state.dart';
import 'package:new_project/features/auth/presentation/login_error_dialog.dart';
import '../logic/cubit/login_cubit.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_, role) {
            switch (role.toLowerCase()) {
              case 'supervisor':
                context.pushReplacementNamed(Routes.centerDashboard);
                break;
              case 'manager':
                context.pushReplacementNamed(Routes.adminDashboard);
                break;
              case 'employee':
                context.pushReplacementNamed(Routes.employeeDashboard);
                break;
              default:
                _showErrorDialog(context, 'صلاحية غير معروفة');
            }
          },
          error: (message) {
            _showErrorDialog(context, message);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => LoginErrorDialog(
        message: message,
        onRetry: () {},
      ),
    );
  }
}
