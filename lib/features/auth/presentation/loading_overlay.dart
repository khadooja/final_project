import 'package:flutter/material.dart';
import 'package:new_project/Core/theme/colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: ColoredBox(
        color: AppColors.textColor2,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
