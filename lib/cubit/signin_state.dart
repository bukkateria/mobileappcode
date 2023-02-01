part of 'signin_cubit.dart';

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
  emailVerified,
  userInofVerify
}

class SigninState extends Equatable {
  final String email;
  final String password;
  final SigninStatus status;
  const SigninState(
      {required this.email, required this.password, required this.status});

  factory SigninState.initial() {
    return SigninState(email: '', password: '', status: SigninStatus.initial);
  }

  SigninState copyWith(
      {String? email, String? password, SigninStatus? status}) {
    return SigninState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status);
  }

  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  @override
  List<Object> get props => [email, password, status];
}
