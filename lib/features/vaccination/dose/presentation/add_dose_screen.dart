import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/features/vaccination/dose/data/repos/dose_repo.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/vaccination/dose/logic/cubit/dose_cubit.dart';
import 'package:new_project/features/vaccination/dose/presentation/dose_form.dart';

import 'package:get_it/get_it.dart';

class AddDoseScreen extends StatelessWidget {
  const AddDoseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoseCubit>(
      create: (_) => di<DoseCubit>(), // GetIt instance
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(title: const Text('إضافة جرعة')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: DoseForm(),
        ),
      ),
    );
  }
}
