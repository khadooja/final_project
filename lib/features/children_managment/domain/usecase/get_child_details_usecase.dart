import 'package:new_project/Core/networking/api_result.dart';
import 'package:new_project/features/children_managment/data/model/child_edit_details_model.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';

// class GetChildDetailsUseCase {
//   final ChildRepository _repository;

//   GetChildDetailsUseCase(this._repository);

//   Future<ApiResult<ChildEditDetailsModel>> execute(String childId) async {
//     return _repository.getChildDetailsById(childId);
//   }
// }
// features/children_managment/domain/usecase/get_child_details_usecase.dart
import 'package:new_project/features/children_managment/data/model/child_detail_model.dart'; // Your detailed model
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
// You might use Either for error handling from dartz package
// import 'package:dartz/dartz.dart';
// import 'package:your_project/core/error/failures.dart'; // Your Failure class

class GetChildDetailsUseCase {
  final ChildRepository repository;

  GetChildDetailsUseCase(this.repository);

  // Define the call method
  // It should accept the childId (String or int, match your repository)
  // It should return Future<ChildDetailModel> or Future<Either<Failure, ChildDetailModel>>
  Future<ApiResult<ChildEditDetailsModel>> call(String childId) async {
    // Assuming your repository method takes a String ID and returns ChildDetailModel
    // If your repository method takes an int, parse it here:
    // final int id = int.parse(childId);
    // return await repository.getChildDetailsById(id);
    return await repository.getChildDetailsById(childId);
  }
}
