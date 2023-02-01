import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

part 'userinfo_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final AuthRepository _authRepository;
  UserInfoCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(UserInfoState.initial());

  void ageChanged(String value) {
    emit(state.copyWith(age: value, status: UserInfoStatus.initial));
  }

  void sexChanged(String value) {
    emit(state.copyWith(sex: value, status: UserInfoStatus.initial));
  }

  void locationChanged(String value) {
    emit(state.copyWith(location: value, status: UserInfoStatus.initial));
  }

  void updateUserData() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: UserInfoStatus.submitting));
    try {
      final result = await _authRepository.submitUserInfoData(
          age: state.age, sex: state.sex, location: state.location);
      if (result == true) {
        emit(state.copyWith(status: UserInfoStatus.success));
      } else {
        emit(state.copyWith(status: UserInfoStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: UserInfoStatus.error));
    }
  }
}
