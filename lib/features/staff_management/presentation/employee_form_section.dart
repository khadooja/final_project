import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/staff_management/logic/employee.state.dart';
import 'package:new_project/features/staff_management/logic/employee_cubit.dart';
import 'package:new_project/features/staff_management/presentation/form_present_employee.dart';

class EmployeeFormSection extends StatefulWidget {
  final SearchPersonResponse? searchResult;

  const EmployeeFormSection({super.key, this.searchResult});

  @override
  State<EmployeeFormSection> createState() => _EmployeeFormSectionState();
}

class _EmployeeFormSectionState extends State<EmployeeFormSection> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<EmployeeCubit>();

    cubit.getNationalitiesAndCities(PersonType.employee);
    cubit.loadCreateEmployeeData().then((_) => _handleSearchResult());
  }

  @override
  void didUpdateWidget(covariant EmployeeFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchResult != widget.searchResult) {
      _handleSearchResult();
    }
  }

  void _handleSearchResult() {
    final cubit = context.read<EmployeeCubit>();
    if (widget.searchResult != null) {
      if (widget.searchResult!.data?.employee != null) {
        cubit.fillFormFromEmployee(widget.searchResult!);
      } else if (widget.searchResult!.data?.person != null) {
        cubit.fillFormFromPerson(widget.searchResult!);
      }
    } else {
      cubit.clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is EmployeeSuccess || state is EmployeeAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
          );
        } else if (state is EmployeeDataFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحميل بيانات الموظف')),
          );
        } else if (state is EmployeePersonFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحميل بيانات الشخص')),
          );
        }
      },
      builder: (context, state) {
        if (state is EmployeeLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return EmployeeForm();
      },
    );
  }
}
