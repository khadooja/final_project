import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/helpers/dropdown_helper/dropdown_storage_helper.dart';
import 'package:new_project/features/guardian_management.dart/domain/repositories/child_guardian_repository.dart';
import 'package:new_project/features/guardian_management.dart/logic/child_guardian_state.dart';

class ChildGuardianCubit extends Cubit<ChildGuardianState> {
  final ChildGuardianRepository _repository;

  ChildGuardianCubit(this._repository) : super(ChildGuardianInitial());

  Future<void> linkGuardianToChild(
      String guardianId, String childId, String relationshipTypeId) async {
    emit(ChildGuardianLoading());
    final result = await _repository.linkGuardianToChild(
        guardianId, childId, relationshipTypeId);
    result.when(
      success: (_) => emit(ChildGuardianSuccess()),
      failure: (error) => emit(
        ChildGuardianFailure(error.message),
      ),
    );
  }

  Future<void> getRelationshipTypes() async {
    emit(ChildGuardianLoadingRelationships());

    // تحقق من التخزين المحلي أولاً
    final cached = await DropdownStorageHelper.getRelationshipTypes();
    if (cached != null && cached.isNotEmpty) {
      emit(ChildGuardianLoadedRelationships(cached));
      return;
    }

    // إذا لم تكن موجودة محليًا، اطلب من API
    final result = await _repository.getRelationshipTypes();
    result.when(
      success: (relationships) async {
        // خزنها محليًا بعد التحميل
        await DropdownStorageHelper.setRelationshipTypes(relationships);
        emit(ChildGuardianLoadedRelationships(relationships));
      },
      failure: (error) => emit(
        ChildGuardianFailure(error.message),
      ),
    );
  }

  Future<void> clearRelationshipTypes() async {
    emit(ChildGuardianLoadingRelationships());
    await DropdownStorageHelper.clearRelationshipTypes();
    emit(ChildGuardianInitial());
  }
}
