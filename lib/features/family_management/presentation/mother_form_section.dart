import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/family_management/logic/mother_cubit.dart';
import 'package:new_project/features/family_management/logic/mother_state.dart';
import 'package:new_project/features/family_management/presentation/form_present.dart';
import 'package:new_project/features/family_management/presentation/form_present_mother.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

class MotherFormSection extends StatefulWidget {
  final SearchPersonResponse? searchResult;

  const MotherFormSection({super.key, this.searchResult});

  @override
  State<MotherFormSection> createState() => _MotherFormSectionState();
}

class _MotherFormSectionState extends State<MotherFormSection> {
  @override
  void initState() {
    super.initState();
    context
        .read<MotherCubit>()
        .getNationalitiesAndCities(PersonType.mother)
        .then((_) => _handleSearchResult());
  }

  @override
  void didUpdateWidget(covariant MotherFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchResult != widget.searchResult) {
      _handleSearchResult();
    }
  }

  void _handleSearchResult() {
    final cubit = context.read<MotherCubit>();
    if (widget.searchResult != null) {
      if (widget.searchResult!.data?.mother != null) {
        cubit.fillFormFromMother(widget.searchResult!);
      } else if (widget.searchResult!.data?.person != null) {
        cubit.fillFormFromPerson(widget.searchResult!);
      }
    } else {
      cubit.clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MotherCubit, MotherState>(
      listener: (context, state) {
        if (state is MotherError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is MotherSuccess || state is MotherAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
          );
        } else if (state is MotherDataFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحميل بيانات الام')),
          );
        } else if (state is MotherPersonFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحميل بيانات الشخص')),
          );
        }
      },
      builder: (context, state) {
        if (state is MotherLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return MotherForm();
      },
    );
  }
}
