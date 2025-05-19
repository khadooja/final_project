import 'package:flutter/material.dart';
import 'package:new_project/Core/routing/routes.dart';

class MenuItemsHelper {
  static List<Map<String, dynamic>> getMenuItems(String role) {
    switch (role.toLowerCase()) {
      case 'manager':
        return [
          {
            "icon": Icons.person_add,
            "label": "إضافة موظف",
            "route": Routes.addEmployee
          },
          {
            "icon": Icons.people,
            "label": "عرض الموظفين",
            "route": Routes.viewEmployees
          },
          {
            "icon": Icons.child_care,
            "label": "إضافة طفل",
            "route": Routes.addFather
          },
          {
            "icon": Icons.list,
            "label": "عرض الأطفال",
            "route": Routes.addFather
          },
        ];
      case 'staff':
        return [
          {
            "icon": Icons.child_care,
            "label": "إضافة طفل",
            "route": Routes.addFather
          },
          {
            "icon": Icons.list,
            "label": "عرض الأطفال",
            "route": Routes.viewChildren
          },
        ];
      case 'Super':
        return [
          {
            "icon": Icons.business,
            "label": "عرض المراكز",
            "route": Routes.viewCenters
          },
          {
            "icon": Icons.add_business,
            "label": " إضافة موظفين",
            "route": Routes.addCenter
          },
          {
            "icon": Icons.business,
            "label": " تقارير",
            "route": Routes.viewCenters
          },
          {
            "icon": Icons.add_business,
            "label": " اضافات تطعيمات",
            "route": Routes.addCenter
          },
          {
            "icon": Icons.add_business,
            "label": "إضافة مركز",
            "route": Routes.addCenter
          },
        ];
      default:
        return getDefaultMenu();
    }
  }

  static List<Map<String, dynamic>> getDefaultMenu() {
    return [
      {
        'role': 'guest',
        'items': [
          {
            "icon": Icons.person_add,
            "label": "إضافة موظف",
            "route": Routes.addEmployee
          },
          {
            "icon": Icons.people,
            "label": "عرض الموظفين",
            "route": Routes.viewEmployees
          },
          {
            "icon": Icons.child_care,
            "label": "إضافة طفل",
            "route": Routes.addFather
          },
          {
            "icon": Icons.list,
            "label": "عرض الأطفال",
            "route": Routes.addFather
          },
        ],
      }
    ];
  }
}
