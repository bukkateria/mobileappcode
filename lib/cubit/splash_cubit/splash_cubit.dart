import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../my_preference.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository _authRepository;
  SplashCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SplashState.initial());

  void checkCredentials(String userType, String uid) async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic>? doc;
    if (user != null) {
      final data = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();
      doc = data.data();
    }
    emit(state.copyWith(userType: userType, uid: uid));

    //if (!state.isValid) return;

    MyPref myPref = MyPref.getInstance();
    print('user is : $user');
    print('user id is : ${user?.uid}');
    if (user != null && user.emailVerified == false) {
      log('email not verified called in splash cubit');
      emit(state.copyWith(status: SplashStatus.emailVerified));
    } else if (uid == "" && user?.uid == null) {
      log('user is null called in splash cubit');
      myPref.getData().then((value) {
        print("----------------------${value}");
        if (value == "ONBOARD" || value == "BOTH") {
          emit(state.copyWith(status: SplashStatus.signup));
        } else {
          log('onboard section is excuted');
          emit(state.copyWith(status: SplashStatus.onboard));
        }
      });
    } else if (user != null &&
        doc!.containsKey('isInfoAdded') &&
        doc['isInfoAdded'] == true) {
      log('user not null called in splash cubit');

      print("----------------------${userType}");
      if (userType == "vendor") {
        emit(state.copyWith(status: SplashStatus.vendorHome));
      } else {
        emit(state.copyWith(status: SplashStatus.home));
      }

      // else {
      //   emit(state.copyWith(status: SplashStatus.userInfoVerify));
      // }
    } else if (user != null &&
        doc!.containsKey('isInfoAdded') &&
        doc['isInfoAdded'] == false) {
      emit(state.copyWith(status: SplashStatus.userInfoVerify));
    } else {
      log('user signup called in splash cubit');
      emit(state.copyWith(status: SplashStatus.signup));
    }

    /* try {
      await _authRepository.updateUser(userType: state.userType, uid: state.uid);
      emit(state.copyWith(status: SplashStatus.success));
    } catch (_) {
      emit(state.copyWith(status: SplashStatus.error));
    }*/
  }

/*  void setUserType(String userType) async {
    MyPref.getInstance().setData(userType: userType);
    emit(state.copyWith(status: SplashStatus.saved));
  }*/

  getUser() {
    return _authRepository.user;
  }
}
