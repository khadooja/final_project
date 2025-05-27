import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/di/get_it.dart';
import 'package:new_project/features/vaccination/stage/logic/cubit/StageCubit.dart';
import 'package:new_project/features/vaccination/stage/presentation/StageForm.dart';

class AddStageScreen extends StatelessWidget {
  const AddStageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<Stagecubit>(
      create: (_) => di<Stagecubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(title: const Text('إضافة مرحلة')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: StageForm(),
        ),
      ),
    );
  }
}
