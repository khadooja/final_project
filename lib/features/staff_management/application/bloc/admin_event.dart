part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class FetchDropdownDataEvent extends AdminEvent {
  const FetchDropdownDataEvent();
  @override
  List<Object> get props => [];
}

class FetchEmployeesWithPaginationEvent extends AdminEvent {
  final int? page;

  const FetchEmployeesWithPaginationEvent({this.page});

  @override
  List<Object> get props => [page ?? 0];
}

class ResetPersonDataEvent extends AdminEvent {}

class FetchEmployeesEvent extends AdminEvent {}

// في ملف admin_event.dart
class AddEmployeeEvent extends AdminEvent {
  final bool isPersonExist;
  final Map<String, dynamic> employeeData;

  const AddEmployeeEvent({
    required this.isPersonExist,
    required this.employeeData,
  });

  @override
  List<Object> get props => [isPersonExist, employeeData];
}

class UpdateEmployeeEvent extends AdminEvent {
  final EmployeeModel employeeModel;

  const UpdateEmployeeEvent(
    this.employeeModel,
  );

  @override
  List<Object> get props => [employeeModel];
}

class DeactivateEmployeeEvent extends AdminEvent {
  final String employeeId;
  const DeactivateEmployeeEvent(this.employeeId);
  @override
  List<Object> get props => [employeeId];
}

// في admin_event.dart
class CheckPersonEvent extends AdminEvent {
  final String nationalId;
  final bool checkAsEmployee;

  const CheckPersonEvent(this.nationalId, {this.checkAsEmployee = false});

  @override
  List<Object> get props => [nationalId, checkAsEmployee];
}
