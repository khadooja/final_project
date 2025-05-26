import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/dropdown_helper/dropdown_storage_helper.dart';
import 'package:new_project/features/children_managment/data/model/child_model.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_child_details_usecase.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_children_usecase.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_state.dart';

class ChildCubit extends Cubit<ChildState> {
  final ChildRepository _repository;
  final GetChildrenUseCase _getChildrenUseCase;

  ChildCubit(this._repository, this._getChildrenUseCase, GetChildDetailsUseCase getChildDetailsUseCase)
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

  Future<void> addChild(ChildModel childData) async {
    emit(ChildLoading());
    final result = await _repository.addChild(childData);
    result.when(
      success: (_) => emit(const ChildSaveError("Child saved successfully")),
      failure: (error) => emit(
        ChildFailure(error.message),
      ),
    );
  }

  Future<void> updateChild(String id, Map<String, dynamic> childData) async {
    emit(ChildLoading());
    final result = await _repository.updateChild(id, childData);
    result.when(
      success: (_) => emit(const ChildSaveError( "تم التعديل بنجاح")),
      failure: (error) => emit(
        ChildFailure(error.message),
      ),
    );
  }

 Future<void> loadInitialDropdownData() async {
  emit(ChildLoadingDropdowns());
  try {
    // تحميل البيانات من التخزين المحلي
    final nationalities = await DropdownStorageHelper.getNationalities();
    final countries = await DropdownStorageHelper.getCountries();
    final specialCases = await DropdownStorageHelper.getSpecialCases();

    final bool hasCachedData =
        nationalities != null && countries != null && specialCases != null;

    if (hasCachedData) {
      print('📦 تم تحميل البيانات من التخزين المحلي');
      emit(ChildLoadedDropdowns(
        nationalities: nationalities!,
        countries: countries!,
        specialCases: specialCases!,
      ));
      return;
    }

    // تحميل من الـ API
    final result = await _repository.getNationalitiesAndCitiesandCases();

    result.when(
      success: (data) async {
        print('✅ تم تحميل البيانات من API');

        // تخزين البيانات
        await Future.wait([
          DropdownStorageHelper.setNationalities(data.nationalities),
          DropdownStorageHelper.setCountry(data.countries),
          DropdownStorageHelper.setSpecialCases(data.specialCases),
        ]);

        emit(ChildLoadedDropdowns(
          nationalities: data.nationalities,
          countries: data.countries,
          specialCases: data.specialCases,
        ));
      },
      failure: (error) {
        print('💥 فشل تحميل البيانات من API: ${error.message}');
        emit(ChildFailure(error.message));
      },
    );
  } catch (e) {
    print('💣 خطأ غير متوقع: $e');
    emit(ChildFailure("حدث خطأ أثناء تحميل البيانات"));
  }
}

  
}
