import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/dashboardcard.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/routing/routes.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 3,
      children: [
        DashboardCard(
          icon: Icons.list,
          title: "عرض الأطفال",
          onTap: () => context.pushNamed(Routes.viewChildren),
        ),
        DashboardCard(
          icon: Icons.child_care,
          title: "إضافة طفل",
          onTap: () => context.pushNamed(Routes.addFather),
        ),
        DashboardCard(
          icon: Icons.people,
          title: "عرض الموظفين",
          onTap: () => context.pushNamed(Routes.viewEmployees),
        ),
        DashboardCard(
          icon: Icons.person_add,
          title: "إضافة موظف",
          onTap: () => context.pushNamed(Routes.addEmployee),
        ),
      ],
    );
  }
}
