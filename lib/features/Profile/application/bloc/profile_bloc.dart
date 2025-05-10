import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/Profile/application/bloc/profileEvents.dart';
import 'package:new_project/features/Profile/application/bloc/profileStates.dart';
import 'package:new_project/features/Profile/domain/entities/profile.dart';
import 'package:new_project/features/Profile/domain/repository.dart';
import 'package:new_project/features/Profile/domain/usecase/getprofileusecase.dart';
import 'package:new_project/features/Profile/domain/usecase/updatapasswordusecase.dart';
import 'package:new_project/features/Profile/domain/usecase/updateprofileusecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  ProfileBloc(
    super.initialState, {
    required this.profileRepository,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.updatePasswordUseCase,
  });

  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileEvent) {
      yield* _mapLoadProfileEventToState(event);
    } else if (event is UpdatePasswordEvent) {
      yield* _mapUpdatePasswordEventToState(event);
    } else if (event is UpdateProfileEvent) {
      yield* _mapUpdateProfileEventToState(event);
    }
  }

  Stream<ProfileState> _mapLoadProfileEventToState(dynamic event) async* {
    yield ProfileLoadingState();

    try {
      final profile = await getProfileUseCase.execute(event.userId);
      yield ProfileLoadedState(profile);
    } catch (e) {
      yield ProfileErrorState('Failed to load profile');
    }
  }

  Stream<ProfileState> _mapUpdatePasswordEventToState(
      UpdatePasswordEvent event) async* {
    yield ProfileLoadingState();
    try {
      final success = await updatePasswordUseCase.execute(
          event.oldPassword, event.newPassword);
      if (success) {
        yield ProfileUpdatedState(UserProfile(
          fullName: "New Name", // تغيير 'name' إلى 'fullName'
          email: "example@email.com",
          phoneNumber: "123456789",
          gender: "Male",
          nationality: "Country",
          location: "City",
          position: "Job Position",
          workplace: "Company",
          role: "User Role",
          profileImageUrl: "https://example.com/image.jpg",
          isactive: true,
          employment_date: DateTime.now(),
        ));
      } else {
        yield ProfileErrorState('Failed to update password');
      }
    } catch (e) {
      yield ProfileErrorState('Failed to update password');
    }
  }

  Stream<ProfileState> _mapUpdateProfileEventToState(
      UpdateProfileEvent event) async* {
    yield ProfileLoadingState();

    try {
      final success = await updateProfileUseCase.execute(event.profile);
      if (success) {
        yield ProfileUpdatedState(event.profile);
      } else {
        yield ProfileErrorState('Failed to update profile');
      }
    } catch (e) {
      yield ProfileErrorState('Failed to update profile');
    }
  }
}
