import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/family_management/logic/father_cubit.dart';
import 'package:new_project/features/family_management/logic/father_state.dart';
import 'package:new_project/features/family_management/presentation/form_present.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';

class FatherFormSection extends StatefulWidget {
  final SearchPersonResponse? searchResult;

  const FatherFormSection({super.key, this.searchResult});

  @override
  State<FatherFormSection> createState() => _FatherFormSectionState();
}

class _FatherFormSectionState extends State<FatherFormSection> {
  @override
  void initState() {
    super.initState();
    context.read<FatherCubit>().getNationalitiesAndCities(PersonType.father)
        .then((_) => _handleSearchResult());
  }

  @override
  void didUpdateWidget(covariant FatherFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchResult != widget.searchResult) {
      _handleSearchResult();
    }
  }

  void _handleSearchResult() {
    final cubit = context.read<FatherCubit>();
    if (widget.searchResult != null) {
      if (widget.searchResult!.data?.father != null) {
        cubit.fillFormFromFather(widget.searchResult!);
      } else if (widget.searchResult!.data?.person != null) {
        cubit.fillFormFromPerson(widget.searchResult!);
      }
    } else {
      cubit.clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FatherCubit, FatherState>(
      listener: (context, state) {
        if (state is FatherError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is FatherSuccess || state is FatherAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
          );
        } else if (state is FatherDataFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحميل بيانات الأب')),
          );
        } else if (state is FatherPersonFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحميل بيانات الشخص')),
          );
        }
      },
      builder: (context, state) {
        if (state is FatherLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return  FatherForm();
      },
    );
  }
}