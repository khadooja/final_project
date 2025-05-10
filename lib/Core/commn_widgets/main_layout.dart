import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/commn_widgets/sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String userName;
  final String userRole;
  final List<Map<String, dynamic>> menuItems;
  final Function(String)? onMenuItemTap;

  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    required this.userName,
    required this.userRole,
    required this.menuItems,
    this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Sidebar(
          menuItems: menuItems,
          onItemTap: onMenuItemTap,
        ),
        Expanded(
          child: Column(
            children: [
              TopBar(title: title),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}
