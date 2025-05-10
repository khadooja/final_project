// profile_screen.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/sidebar.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/routing/routes.dart';
import 'package:new_project/features/Profile/application/bloc/profileEvents.dart';
import 'package:new_project/features/Profile/application/bloc/profileStates.dart';
import 'package:new_project/features/Profile/application/bloc/profile_bloc.dart';
import 'package:new_project/features/Profile/data/repositories/apiclient.dart';
import 'package:new_project/features/Profile/data/repositories/profile_repository_iml.dart';
import 'package:new_project/features/Profile/domain/usecase/getprofileusecase.dart';
import 'package:new_project/features/Profile/domain/usecase/updatapasswordusecase.dart';
import 'package:new_project/features/Profile/domain/usecase/updateprofileusecase.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required String userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ProfileBloc(
          ProfileInitialState(),
          profileRepository:
              ProfileRepositoryImpl(apiClient: ApiClient(dio: Dio())),
          getProfileUseCase: GetProfileUseCase(
              repository:
                  ProfileRepositoryImpl(apiClient: ApiClient(dio: Dio()))),
          updateProfileUseCase: UpdateProfileUseCase(
              repository:
                  ProfileRepositoryImpl(apiClient: ApiClient(dio: Dio()))),
          updatePasswordUseCase: UpdatePasswordUseCase(
              profileRepository:
                  ProfileRepositoryImpl(apiClient: ApiClient(dio: Dio()))),
        ),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProfileLoadedState) {
              return _buildProfileLayout(state.profile, context);
            } else if (state is ProfileUpdatedState) {
              return _buildProfileLayout(state.profile, context);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileLayout(profile, BuildContext context) {
    return Row(
      children: [
        // النافبار الجانبي
        const Sidebar(
          menuItems: [
            {
              "icon": Icons.account_circle,
              "label": "الملف الشخصي",
              "route": Routes.profile
            },
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
              "route": Routes.addChild
            },
            {
              "icon": Icons.list,
              "label": "عرض الأطفال",
              "route": Routes.viewChildren
            },
          ],
        ),
        // الجزء الرئيسي من الصفحة
        Expanded(
          child: Column(
            children: [
              // الشريط العلوي
              const TopBar(
                title: '',
              ),
              // محتوى الصفحة
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildProfileContent(profile, context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent(profile, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات المستخدم
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الملف الشخصي",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildProfileInfoRow("الاسم الكامل", profile.fullName),
                  _buildProfileInfoRow("البريد الإلكتروني", profile.email),
                  _buildProfileInfoRow("رقم الهاتف", profile.phoneNumber),
                  _buildProfileInfoRow("الموقع", profile.location),
                  _buildProfileInfoRow("الجنسية", profile.nationality),
                  _buildProfileInfoRow("الجنس", profile.gender),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // أزرار التعديل
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _showEditProfileDialog(context, profile);
                },
                child: const Text("تعديل البيانات الشخصية"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _showChangePasswordDialog(context);
                },
                child: const Text("تغيير كلمة المرور"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تغيير كلمة المرور'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'كلمة المرور الحالية'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'كلمة المرور الجديدة'),
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'تأكيد كلمة المرور الجديدة'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call update password event
                const oldPassword = 'old_password';
                const newPassword = 'new_password';
                context
                    .read<ProfileBloc>()
                    .add(UpdatePasswordEvent(oldPassword, newPassword));
                Navigator.pop(context);
              },
              child: const Text('تعديل'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, profile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تعديل البيانات الشخصية'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                controller: TextEditingController(text: profile.fullName),
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'البريد الإلكتروني'),
                controller: TextEditingController(text: profile.email),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                controller: TextEditingController(text: profile.phoneNumber),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'الموقع'),
                controller: TextEditingController(text: profile.location),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'الجنسية'),
                controller: TextEditingController(text: profile.nationality),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'الجنس'),
                controller: TextEditingController(text: profile.gender),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedProfile = profile.copyWith();
                context
                    .read<ProfileBloc>()
                    .add(UpdateProfileEvent(updatedProfile));
                Navigator.pop(context);
              },
              child: const Text('تعديل'),
            ),
          ],
        );
      },
    );
  }
}
