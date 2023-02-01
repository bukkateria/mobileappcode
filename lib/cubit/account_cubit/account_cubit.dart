import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/postRepository/post_repository.dart';


part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AuthRepository _authRepository;
  final PostRepository _postRepository;

  AccountCubit(
      {required AuthRepository authRepository,
        required PostRepository postRepository})
      : _authRepository = authRepository,
        _postRepository = postRepository,
        super(AccountState.initial());

  void statusChange(AccountStatus status) {
    emit(state.copyWith( status: status));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: AccountStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: AccountStatus.initial));
  }
  void imageChanged(String value) {
    emit(state.copyWith(image: value, status: AccountStatus.initial));
  }
  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: AccountStatus.initial));
  }
  void userTypeChanged(String value) {
    emit(state.copyWith(userType: value, status: AccountStatus.initial));
  }
  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: AccountStatus.initial));
  }
  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: AccountStatus.initial));
  }

  updateImage(String uid, name){
    if(state.image != null){
      try {
        _postRepository.uploadImage(
            imageFile: File(state.image!), name: name, uid: uid).then((
            value) async {
          await _authRepository.updateUser(
            image: value,
              uid: FirebaseAuth.instance.currentUser?.uid ?? "");
          emit(state.copyWith(status: AccountStatus.success));
        });
      }catch(ex){
        emit(state.copyWith(status: AccountStatus.error));
      }
    }
  }

  updatePasswordOrName() async {
    emit(state.copyWith(status: AccountStatus.updateSubmitting));

    if(state.password!= null && state.password!.isNotEmpty){
      try {
        _authRepository.updatePassword(password: state.password ?? "").then((value) async {
          if(state.name != null){
            await _authRepository.updateUser(name: state.name, uid: FirebaseAuth.instance.currentUser?.uid ?? "");
            emit(state.copyWith(status: AccountStatus.updateSuccess));
          }
        });
      }catch(ex){
        emit(state.copyWith(status: AccountStatus.updateError));
      }
    }else if(state.name != null && state.name!.isNotEmpty){
      try{
        await _authRepository.updateUser(name: state.name, uid: FirebaseAuth.instance.currentUser?.uid ?? "");
        emit(state.copyWith(status: AccountStatus.updateSuccess));
      }catch(ex){
        emit(state.copyWith(status: AccountStatus.updateError));
      }
    }else{
      emit(state.copyWith(status: AccountStatus.missingField));
    }
  }

  updateUserType() async {
   // emit(state.copyWith(status: AccountStatus.submitting));
    if(state.userType == null){
      emit(state.copyWith(status: AccountStatus.missingField));
    }else {
      try {
        await _authRepository.updateUser(userType: state.userType,
            uid: FirebaseAuth.instance.currentUser?.uid ?? "");
        emit(state.copyWith(status: AccountStatus.success));
      } catch (ex) {
        emit(state.copyWith(status: AccountStatus.error));
      }
    }
  }

  updateContactInfo() async {
    emit(state.copyWith(status: AccountStatus.contactSubmitting));
    if((state.phone ?? "").isEmpty && (state.address ?? "").isEmpty){
      emit(state.copyWith(status: AccountStatus.missingField));
    }else {
      try {
        await _authRepository.updateUser(address: state.address, phone: state.phone,
            uid: FirebaseAuth.instance.currentUser?.uid ?? "").then((value) {
              emit(state.copyWith(status: AccountStatus.contactSuccess));
        });
      } catch (ex) {
        emit(state.copyWith(status: AccountStatus.contactError));
      }
    }
  }



}
