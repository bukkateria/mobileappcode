import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../my_preference.dart';


part 'roleview_state.dart';

class RoleViewCubit extends Cubit<RoleViewState> {
  final AuthRepository _authRepository;
  RoleViewCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(RoleViewState.initial());


  void updateUserType(String userType, String uid) async {
    emit(state.copyWith(userType: userType,uid: uid));

    if (!state.isValid) return;
    emit(state.copyWith(status: RoleViewStatus.submitting));
    try {
      await _authRepository.updateUser(userType: state.userType, uid: state.uid);
      emit(state.copyWith(status: RoleViewStatus.success));
    } catch (_) {
      emit(state.copyWith(status: RoleViewStatus.error));
    }
  }

  void setUserType(String userType) async {
    MyPref.getInstance().setData(userType: userType);
    emit(state.copyWith(status: RoleViewStatus.saved));
  }

   getUser(){
    return _authRepository.user;
  }
}
