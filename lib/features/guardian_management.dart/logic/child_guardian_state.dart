import 'package:equatable/equatable.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';

abstract class ChildGuardianState extends Equatable {
  const ChildGuardianState();

  @override
  List<Object?> get props => [];
}

class ChildGuardianInitial extends ChildGuardianState {}

class ChildGuardianLoading extends ChildGuardianState {}

class ChildGuardianSuccess extends ChildGuardianState {}

class ChildGuardianFailure extends ChildGuardianState {
  final String message;

  const ChildGuardianFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ChildGuardianLoadingRelationships extends ChildGuardianState {}

class ChildGuardianLoadedRelationships extends ChildGuardianState {
  final List<RelationshipTypeModel> relationships;

  const ChildGuardianLoadedRelationships(this.relationships);

  @override
  List<Object?> get props => [relationships];
}
