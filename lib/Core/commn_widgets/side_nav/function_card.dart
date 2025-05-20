import 'package:flutter/material.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/Core/theme/styles.dart';

class FunctionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FunctionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.navColor),
            const SizedBox(height: 10),
            Text(label, style: AppTextStyles.navtext, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
