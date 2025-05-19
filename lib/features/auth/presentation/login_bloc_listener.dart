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
            if (role.toLowerCase() == 'admin') {
              context.pushReplacementNamed(Routes.adminDashboard);
            } else if (role.toLowerCase() == 'manager') {
              context.pushReplacementNamed(Routes.managerDashboard);
            } else if (role.toLowerCase() == 'employee') {
              context.pushReplacementNamed(Routes.employeeDashboard);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('صلاحية غير معروفة')),
              );
            }
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
