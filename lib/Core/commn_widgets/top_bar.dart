import 'package:flutter/material.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/theme/colors.dart';

class TopBar extends StatelessWidget {
  final String title;

  const TopBar({super.key, required this.title});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.textBox,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "وزارة الصحة",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),

          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () {
              context.pop();
            },
          ),

          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: " ...ابحث",
                  hintStyle: const TextStyle(color: AppColors.textBox),
                  suffixIcon:
                      const Icon(Icons.search, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                        color: AppColors.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // الأيقونات على اليسار
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications,
                    color: AppColors.primaryColor),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.primaryColor),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person, color: AppColors.primaryColor),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
