import 'package:flutter/material.dart';
import 'package:new_project/Core/theme/colors.dart';

class UserHeader extends StatelessWidget {
  final String name;
  final String role;

  const UserHeader({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.person, size: 60, color: AppColors.navColor),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(color: AppColors.textColor2, fontSize: 16)),
        Text(role, style: const TextStyle(color: AppColors.textColor2, fontSize: 14)),
      ],
    );
  }
}
