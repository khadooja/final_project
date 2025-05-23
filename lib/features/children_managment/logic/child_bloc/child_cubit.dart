import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/shared_pref_helper.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_children_usecase.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_state.dart';

class ChildCubit extends Cubit<ChildState> {
  final ChildRepository _repository;
  final GetChildrenUseCase _getChildrenUseCase;

  ChildCubit(this._repository, this._getChildrenUseCase)
      : super(ChildInitial());

//جلب الأطفال
  Future<void> fetchChildrenList() async {
    emit(ChildrenListLoading());
    final result = await _getChildrenUseCase.execute();
    result.when(
      success: (childListResponse) {
        emit(ChildrenListLoaded(childListResponse));
      },
      failure: (error) {
        emit(ChildrenListError(error.message));
      },
    );
  }

  Future<void> addChild(Map<String, dynamic> childData) async {
    emit(ChildLoading());
    final result = await _repository.addChild(childData);
    result.when(
      success: (_) => emit(ChildSuccess(message: "تمت إضافة الطفل بنجاح")),
      failure: (error) => emit(
        ChildFailure(error.message),
      ),
    );
  }

  Future<void> updateChild(String id, Map<String, dynamic> childData) async {
    emit(ChildLoading());
    final result = await _repository.updateChild(id, childData);
    result.when(
      success: (_) => emit(ChildSuccess(message: "تم التعديل بنجاح")),
      failure: (error) => emit(
        ChildFailure(error.message),
      ),
    );
  }

  Future<void> loadInitialDropdownData() async {
    emit(ChildLoadingDropdowns());

    try {
      final nationalities = await StorageHelper.getNationalities();
      final countries = await StorageHelper.getCountries();
      final specialCases = await StorageHelper.getSpecialCases();

      if (nationalities == null || countries == null || specialCases == null) {
        final result = await _repository.getNationalitiesAndCitiesandCases();
        result.when(
          success: (data) async {
            await Future.wait([
              StorageHelper.setNationalities(data.nationalities),
              StorageHelper.setCountry(data.countries),
              StorageHelper.setSpecialCases(data.specialCases),
            ]);
          },
          failure: (error) => emit(
            ChildFailure(error.message),
          ),
        );
      }

      emit(ChildLoadedDropdowns(
        nationalities: await StorageHelper.getNationalities() ?? [],
        countries: await StorageHelper.getCountries() ?? [],
        specialCases: await StorageHelper.getSpecialCases() ?? [],
      ));
    } catch (e) {
      emit(ChildFailure("حدث خطأ أثناء تحميل البيانات"));
    }
  }
}
