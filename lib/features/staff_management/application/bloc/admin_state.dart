part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class EmployeesLoadedWithPagination extends AdminState {
  final List<EmployeeModel> employees;
  final int totalEmployees;
  final int currentPage;
  final int totalPages;

  const EmployeesLoadedWithPagination({
    required this.employees,
    required this.totalEmployees,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props =>
      [employees, totalEmployees, currentPage, totalPages];
}

class EmployeesLoaded extends AdminState {
  final List<EmployeeModel> employees;

  const EmployeesLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeAddedSuccessfully extends AdminState {}

class EmployeeFoundState extends AdminState {
  final EmployeeModel employee;

  const EmployeeFoundState(this.employee);

  @override
  List<Object> get props => [employee];
}

class PersonFound extends AdminState {
  final PersonModel person;

  const PersonFound(this.person);

  @override
  List<Object> get props => [person];
}

class DropdownDataLoaded extends AdminState {
  final DropdownData dropdownData;

  const DropdownDataLoaded(this.dropdownData);

  @override
  List<Object> get props => [dropdownData];
}

class PersonNotFound extends AdminState {
  final String message;

  const PersonNotFound({required this.message});

  @override
  List<Object> get props => [message];
}

class PersonDataReset extends AdminState {}

class EmployeeUpdatedSuccessfully extends AdminState {
  final List<EmployeeModel> employees;

  const EmployeeUpdatedSuccessfully(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeDeactivated extends AdminState {}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object> get props => [message];
}
