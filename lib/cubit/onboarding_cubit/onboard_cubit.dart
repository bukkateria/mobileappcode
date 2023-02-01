import 'package:bloc/bloc.dart';
import 'package:bukateria/my_preference.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  final AuthRepository _authRepository;
  OnboardCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(OnboardState.initial());


  void setOnboard(String onboard) async {
    MyPref.getInstance().setData(onboard: onboard);
    emit(state.copyWith(status: OnboardStatus.success));
  }

  getUser(){
    return _authRepository.user;
  }
}
