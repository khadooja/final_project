import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/dashboardcard.dart';
import 'package:new_project/Core/helpers/extension.dart';
import 'package:new_project/Core/routing/routes.dart';

class DashboardSection extends StatelessWidget {
  final String role;

  const DashboardSection({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];

    switch (role.toLowerCase()) {
      case 'manager':
        cards = [
          DashboardCard(icon: Icons.list, title: "عرض الأطفال", onTap: () => context.pushNamed(Routes.viewChildren)),
          DashboardCard(icon: Icons.child_care, title: "إضافة طفل", onTap: () => context.pushNamed(Routes.addFather)),
          DashboardCard(icon: Icons.people, title: "عرض الموظفين", onTap: () => context.pushNamed(Routes.viewEmployees)),
          DashboardCard(icon: Icons.person_add, title: "إضافة موظف", onTap: () => context.pushNamed(Routes.addEmployee)),
        ];
        break;
      case 'staff':
        cards = [
          DashboardCard(icon: Icons.child_care, title: "إضافة طفل", onTap: () => context.pushNamed(Routes.addFather)),
          DashboardCard(icon: Icons.list, title: "عرض الأطفال", onTap: () => context.pushNamed(Routes.viewChildren)),
        ];
        break;
      case 'super':
        cards = [
          DashboardCard(icon: Icons.business, title: "عرض المراكز", onTap: () => context.pushNamed(Routes.viewCenters)),
          DashboardCard(icon: Icons.add_business, title: "إضافة موظفين", onTap: () => context.pushNamed(Routes.addCenter)),
          //DashboardCard(icon: Icons.business, title: "تقارير", onTap: () => context.pushNamed(Routes.viewReports)),
          //DashboardCard(icon: Icons.add_business, title: "إضافات تطعيمات", onTap: () => context.pushNamed(Routes.addVaccination)),
          DashboardCard(icon: Icons.add_business, title: "إضافة مركز", onTap: () => context.pushNamed(Routes.addCenter)),
        ];
        break;
      default:
        cards = [
          DashboardCard(icon: Icons.person, title: "الرئيسية", onTap: () => context.pushNamed(Routes.adminDashboard)),
        ];
        break;
    }

    return GridView.count( 
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 3,
      children: cards,
);

  }
}
