import 'package:flutter/material.dart';
import 'package:new_project/Core/routing/routes.dart';

class MenuItemsHelper {
  static List<Map<String, dynamic>> getMenuItems(String role) {
    switch (role.toLowerCase()) {
      case 'manager':
        return [
          {"icon": Icons.person_add, "label": "إضافة موظف", "route": Routes.addEmployee},
          {"icon": Icons.people, "label": "عرض الموظفين", "route": Routes.viewEmployees},
          {"icon": Icons.child_care, "label": "إضافة طفل", "route": Routes.addFather},
          {"icon": Icons.list, "label": "عرض الأطفال", "route": Routes.viewChildren},
        ];
      case 'staff':
        return [
          {"icon": Icons.child_care, "label": "إضافة طفل", "route": Routes.addFather},
          {"icon": Icons.list, "label": "عرض الأطفال", "route": Routes.viewChildren},
        ];
      case 'supervisor':
        return [
          {"icon": Icons.business, "label": "ادارة المستوصفات", "route": Routes.viewCenters},
          {"icon": Icons.add_business, "label": "ادارة الموظفين", "route": Routes.addCenter},
          {"icon": Icons.business, "label": " التقارير العامة", "route": Routes.viewReports},
          {"icon": Icons.add_business, "label": "ادارة تطعيمات", "route": Routes.addVaccination},
          {"icon": Icons.add_business, "label": "إضافة مركز", "route": Routes.addCenter},
        ];
      default:
        return [
          {"icon": Icons.person, "label": "الرئيسية", "route": Routes.adminDashboard},
        ];
    }
  }
}
