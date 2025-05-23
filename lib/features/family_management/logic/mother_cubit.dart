import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/family_management/data/model/mother_model.dart';
import 'package:new_project/features/family_management/domain/repository/motherRepository.dart';
import 'package:new_project/features/family_management/logic/mother_state.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/domain/repositories/personal_repo.dart';

class MotherCubit extends Cubit<MotherState> {
  final MotherRepository _motherRepo;
  final PersonRepository _personRepository;

  MotherCubit(this._personRepository, this._motherRepo)
      : super(MotherInitial());

  Future<void> addMother(MotherModel model) async {
    emit(MotherLoading());
    final result = await _motherRepo.addMother(model);
    result.when(
      success: (_) => emit(MotherAddSuccess()),
      failure: (error) => emit(MotherFailure(
        (error.message),
      )),
    );
  }

  Future<void> updateMother(String id, MotherModel model) async {
    emit(MotherLoading());
    final result = await _motherRepo.updateMother(id, model);
    result.when(
      success: (_) => emit(MotherUpdateSuccess()),
      failure: (error) => emit(MotherFailure((error.message))),
    );
  }

  Future<void> toggleActivation(String id) async {
    emit(MotherLoading());
    final result =
        await _personRepository.toggleActivation(PersonType.mother, id, true);
    result.when(
      success: (_) => emit(MotherToggleActivationSuccess()),
      failure: (error) => emit(MotherFailure((error.message))),
    );
  }

  Future<void> searchFatherById(String id) async {
    emit(MotherLoading());
    final result =
        await _personRepository.searchPersonById( id, PersonType.mother);
    result.when(
      success: (data) => emit(MotherSearchSuccess(data)),
      failure: (error) => emit(MotherFailure((error.message))),
    );

    Future<void> getNationalitiesAndCities(PersonType type) async {
      emit(MotherLoading());
      final result =
          await _personRepository.getNationalitiesAndCities(PersonType.mother);
      result.when(
        success: (data) => emit(MotherNationalitiesAndCitiesLoaded(
          data.$1, // nationalities
          data.$2, // cities
        )),
        failure: (error) => emit(MotherFailure((error.message))),
      );
    }
  }
}
