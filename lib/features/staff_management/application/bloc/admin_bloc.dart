import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/personal_management/data/models/person_model.dart';
import 'package:new_project/features/staff_management/data/model/dropdownclass.dart';
import 'package:new_project/features/staff_management/data/model/employeeResponse.dart';
import 'package:new_project/features/staff_management/data/model/employee_model.dart';
import 'package:new_project/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:new_project/features/staff_management/domain/usecases/add_employee.dart';
import 'package:new_project/features/staff_management/domain/usecases/check_person_existence.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository repository;
  final CheckPersonExistence checkPersonExistence;
  final AddEmployee addEmployee;
  PersonModel? _currentPerson;

  AdminBloc({
    required this.repository,
    required this.checkPersonExistence,
    required this.addEmployee,
  }) : super(AdminInitial()) {
    on<FetchEmployeesWithPaginationEvent>(_onFetchEmployeesWithPagination);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeactivateEmployeeEvent>(_onDeactivateEmployee);
    on<CheckPersonEvent>(_onCheckPerson);
    on<FetchEmployeesEvent>(_onFetchEmployees);
    on<ResetPersonDataEvent>(_onResetPersonData);
    on<FetchDropdownDataEvent>(_onFetchDropdownData);
  }
  @override
  Future<void> _onFetchDropdownData(
      FetchDropdownDataEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final response = await repository.fetchDropdownData();

      // معالجة حالة response فارغ
      if (response == null || response.isEmpty) {
        emit(DropdownDataLoaded(DropdownData(
          healthCenters: [],
          positions: [],
          nationalities: [],
          locations: [],
        )));
        return;
      }

      final dropdownData = DropdownData.fromJson(response);
      emit(DropdownDataLoaded(dropdownData));
    } catch (e) {
      emit(AdminError('Failed to load dropdown data: $e'));
      // إعادة تعيين حالة فارغة
      emit(DropdownDataLoaded(DropdownData(
        healthCenters: [],
        positions: [],
        nationalities: [],
        locations: [],
      )));
    }
  }

  Future<void> _onResetPersonData(
      ResetPersonDataEvent event, Emitter<AdminState> emit) async {
    _currentPerson = null;
    emit(PersonDataReset());
  }

  Future<void> _onFetchEmployeesWithPagination(
      FetchEmployeesWithPaginationEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final responses = await repository.fetchEmployeesWithPagination();
      final response = responses.isNotEmpty
          ? responses.first
          : EmployeesResponse(
              employees: [],
              totalEmployees: 0,
              totalPages: 1,
              currentPage: 1,
            );

      emit(EmployeesLoadedWithPagination(
        employees: response.employees,
        totalEmployees: response.totalEmployees,
        currentPage: event.page ?? 1,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(AdminError("Failed to load employees: ${e.toString()}"));
    }
  }

  Future<void> _onCheckPerson(
    CheckPersonEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      if (event.nationalId.isEmpty) {
        emit(const AdminError("الرجاء إدخال رقم الهوية"));
        return;
      }

      await Future.delayed(
          const Duration(milliseconds: 500)); // محاكاة تأخير الشبكة

      final person = await repository.checkPersonExistence(event.nationalId);

      if (person != null) {
        emit(PersonFound(person));
      } else {
        emit(PersonNotFound(message: "لم يتم العثور على الشخص"));
        await Future.delayed(const Duration(seconds: 1));
        emit(AdminInitial()); // العودة للحالة الأولية بعد عرض الرسالة
      }
    } catch (e) {
      emit(AdminError("حدث خطأ أثناء البحث"));
      await Future.delayed(const Duration(seconds: 1));
      emit(AdminInitial()); // العودة للحالة الأولية بعد الخطأ
    }
  }

  // في AdminBloc
  Future<void> _onAddEmployee(
      AddEmployeeEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final result = await addEmployee.execute(
        isPersonExist: event.isPersonExist,
        data: event.employeeData,
      );

      result.fold(
        (failure) => emit(AdminError(failure.message)),
        (success) {
          if (success) {
            emit(EmployeeAddedSuccessfully());
            add(FetchEmployeesEvent());
          } else {
            emit(const AdminError('Failed to add employee'));
          }
        },
      );
    } catch (e) {
      emit(AdminError("Failed to add employee: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateEmployee(
      UpdateEmployeeEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final success = await repository.updateEmployee(event.employeeModel);

      if (success) {
        final employees = await repository.fetchEmployees();
        emit(EmployeeUpdatedSuccessfully(employees));
      } else {
        emit(const AdminError('Failed to update employee'));
      }
    } catch (e) {
      emit(AdminError("Failed to update employee: ${e.toString()}"));
    }
  }

  Future<void> _onDeactivateEmployee(
      DeactivateEmployeeEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final success = await repository.deactivateEmployee(event.employeeId);

      if (success) {
        emit(EmployeeDeactivated());
        add(FetchEmployeesEvent());
      } else {
        emit(const AdminError('Failed to deactivate employee'));
      }
    } catch (e) {
      emit(AdminError("Failed to deactivate employee: ${e.toString()}"));
    }
  }

  Future<void> _onFetchEmployees(
      FetchEmployeesEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final employees = await repository.fetchEmployees();
      emit(EmployeesLoaded(employees));
    } catch (e) {
      emit(AdminError("Failed to load employees: ${e.toString()}"));
    }
  }
}
