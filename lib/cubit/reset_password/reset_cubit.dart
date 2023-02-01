import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

part 'reset_state.dart';

class ResetCubit extends Cubit<ResetState> {
  final AuthRepository _authRepository;
  ResetCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ResetState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: ResetStatus.initial));
  }

  void resetPassword() async {
    log('start r');
    if (!state.isValid) return;
    log('start r after isvalid');

    emit(state.copyWith(status: ResetStatus.submitting));
    try {
      await _authRepository.resetPassword(email: state.email);

      emit(state.copyWith(status: ResetStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ResetStatus.error));
    }
  }
}
