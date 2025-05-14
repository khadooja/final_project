import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/auth/logic/cubit/login_cubit.dart';
import 'package:new_project/features/auth/logic/cubit/login_state.dart';

class UsernameAndPassword extends StatefulWidget {
  const UsernameAndPassword({super.key});

  @override
  _UsernameAndPasswordState createState() => _UsernameAndPasswordState();
}

class _UsernameAndPasswordState extends State<UsernameAndPassword> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          // اسم المستخدم
          CustomInputField(
            controller: cubit.usernameController,
            label: 'اسم المستخدم',
            validator: (value) => value == null || value.isEmpty
                ? 'الرجاء إدخال اسم المستخدم'
                : null,
          ),
          const SizedBox(height: 16),
          // كلمة المرور
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return CustomInputField(
                controller: cubit.passwordController,
                isObscureText: cubit.isObscureText,
                label: 'كلمة المرور',
                prefixIcon: IconButton(
                  icon: Icon(
                    cubit.isObscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: cubit.togglePasswordVisibility,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء إدخال كلمة المرور'
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}



















/*
class UsernameAndPassword extends StatefulWidget {
  const UsernameAndPassword({super.key});

  @override
  _UsernameAndPasswordState createState() => _UsernameAndPasswordState();
}

class _UsernameAndPasswordState extends State<UsernameAndPassword> {
  bool isObscureText = true; // الحالة الافتراضية لإخفاء كلمة المرور
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          // اسم المستخدم
          CustomInputField(
  label: 'اسم المستخدم',
  validator: (value) => value == null || value.isEmpty
      ? 'الرجاء إدخال اسم المستخدم'
      : null,
),

          const SizedBox(height: 16),
          // كلمة المرور
          CustomInputField(
            controller: passwordController,
            isObscureText: isObscureText,
            label: 'كلمة المرور',
            prefixIcon: IconButton(
              icon: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'الرجاء إدخال كلمة المرور'
                : null,
          ),
        ],
      ),
    );
  }
}*/
