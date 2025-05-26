import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/auth/logic/cubit/login_state.dart';
import 'package:new_project/features/auth/presentation/login_error_dialog.dart';
import '../logic/cubit/login_cubit.dart';

class LoginBlocListener extends StatelessWidget {
  final Widget child;

  const LoginBlocListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (response, role) => _handleSuccess(context, role),
          error: (message) => _showErrorDialog(context, message),
        );
      },
      child: child,
    );
  }

  void _handleSuccess(BuildContext context, String role) {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = _getRouteForRole(role);
      if (route != null) {
        debugPrint('Navigating to: $route');
        Navigator.of(context).pushReplacementNamed(route);
      } else {
        _showErrorDialog(context, 'صلاحية غير معروفة: $role');
      }
    });
  }

  String? _getRouteForRole(String role) {
    switch (role.toLowerCase()) {
      case 'supervisor': return Routes.centerDashboard;
      case 'manager': return Routes.managerDashboard;
      case 'employee': return Routes.employeeDashboard;
      default: return null;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => LoginErrorDialog(
        message: message,
        onRetry: () => Navigator.of(context).pop(),
      ),
    );
  }
}