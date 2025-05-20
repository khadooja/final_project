import 'package:flutter/material.dart';
import 'package:new_project/Core/theme/colors.dart';

class LoginErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const LoginErrorDialog({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.errorColor),
          SizedBox(width: 8),
          Text('فشل تسجيل الدخول'),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onRetry();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorColor, // Button background,
            foregroundColor: AppColors.white, // Text color
          ),
          child: const Text('إعادة المحاولة'),
        ),
      ],
    );
  }
}
