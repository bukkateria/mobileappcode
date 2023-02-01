import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../app/modules/login/views/login_view.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void signupWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      User? userCredential = await _authRepository.signup(
          email: state.email, password: state.password);
      await _authRepository.submitUser(
          email: userCredential?.email ?? "",
          username: state.username,
          userType: "foodie",
          uid: userCredential?.uid ?? "");
      if (userCredential != null && userCredential.emailVerified == false) {
        emit(state.copyWith(status: SignupStatus.emailVerified));
        return;
      } else {
        emit(state.copyWith(status: SignupStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
