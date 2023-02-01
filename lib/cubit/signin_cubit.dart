import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../app/modules/login/views/login_view.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository _authRepository;
  SigninCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SigninState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SigninStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SigninStatus.initial));
  }

  void signinWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: SigninStatus.submitting));
    try {
      final user = await _authRepository.signin(
          email: state.email, password: state.password);
      if (user != null && user.emailVerified == false) {
        emit(state.copyWith(status: SigninStatus.emailVerified));
      } else if (user != null) {
        final data = await FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .get();
        final doc = data.data();
        if (doc!.containsKey('isInfoAdded') && doc['isInfoAdded'] == true) {
          emit(state.copyWith(status: SigninStatus.success));
        } else {
          emit(state.copyWith(status: SigninStatus.userInofVerify));
        }
      }
      // else {
      //   emit(state.copyWith(status: SigninStatus.success));
      // }
    } catch (_) {
      emit(state.copyWith(status: SigninStatus.error));
    }
  }
}
