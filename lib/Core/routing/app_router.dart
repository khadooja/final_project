import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/features/HelthCenter/presentation/showHelthCenters.dart';
import 'package:new_project/features/children_managment/presentation/pages/add_chlid_page.dart';
import 'package:new_project/features/dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:new_project/features/auth/presentation/login_screen.dart';
import 'package:new_project/features/dashboard/presentation/screens/super_dashboard_screen.dart';
import 'package:new_project/features/family_management/presentation/father_screen.dart';
import 'package:new_project/features/family_management/presentation/mother_screen.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/profile/presentation/screens/profile.dart';
import 'package:new_project/features/reports/presentation/report_screen.dart';
import 'package:new_project/features/vaccination/vaccine/presentation/screens/vaccine_screen.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Auth Routes
      case Routes.login:
        return _buildRoute(const LoginScreen());

      case Routes.profile:
        if (args is String) {
          return _buildRoute(ProfileScreen(userRole: args));
        }
        return _errorRoute("Invalid role data passed");

      // Admin Routes
      case Routes.adminDashboard:
        return _buildRoute(
          BlocProvider(
            create: (context) => di<PersonCubit>(),
            child: const AdminDashboardScreen(),
          ),
        );
      case Routes.centerDashboard:
        return _buildRoute(
            const SuperDashboardScreen(),
        );
      case Routes.employeeDashboard:
        return _buildRoute(
          const AdminDashboardScreen(),
        );

      // Children Management
      /* case Routes.addChild:
        return _buildRoute(
          const AddChildPage(username: '', useremail: ''),
        );*/

      // Staff Management
      

      /*case Routes.addEmployee:
        return _buildRoute(
          const AddEmployeePage(username: '', useremail: ''),
        );

      case Routes.viewEmployees:
        if (args is List<EmployeeModel>) {
          return _buildRoute(
            const ViewEmployeesPage(
              selectedFunction: '',
              username: '',
              useremail: '',
            ),
          );
        }*/
      case Routes.addFather:
        return _buildRoute(
          const FatherScreen(),
        );
      case Routes.addMother:
        return _buildRoute(
          const MotherScreen(),
        );
      case Routes.addChild:
        return _buildRoute(
          const AddChildScreen(
            fatherId: 0, // Replace with actual father ID
            motherId: 0, // Replace with actual mother ID
          ),
        );
      // Center Admin Routes
      case Routes.addVaccination:
        return _buildRoute(
          const VaccinesListScreen(),
        );
      case Routes.addCenter:
        return _buildRoute(
          const HealthCentersScreen(),
        );
      case Routes.viewReports:
        return _buildRoute(
          const ReportScreen(),
        );
      default:
        return _errorRoute("Page not found");
    }
  }

  static MaterialPageRoute _buildRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }

  static MaterialPageRoute _errorRoute([String message = 'Unknown error']) {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(message, style: const TextStyle(fontSize: 18)),
              ),
            ));
  }
}
