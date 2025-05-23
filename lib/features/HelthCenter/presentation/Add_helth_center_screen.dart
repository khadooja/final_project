import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/features/HelthCenter/logic/cubit/health_center_cubit.dart';
import 'package:new_project/features/HelthCenter/presentation/HealthCenterForm.dart';

class AddHealthCenterScreen extends StatelessWidget {
  const AddHealthCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HealthCenterCubit>(
      create: (_) => di<HealthCenterCubit>()..fetchCities(),
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(title: const Text('إضافة مركز صحي')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: HealthCenterForm(),
        ),
      ),
    );
  }
}
