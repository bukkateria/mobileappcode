part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error, emailVerified }

class SignupState extends Equatable {
  final String email;
  final String password;
  final String username;
  final SignupStatus status;
  const SignupState(
      {required this.email,
      required this.username,
      required this.password,
      required this.status});

  factory SignupState.initial() {
    return SignupState(
        email: '', username: '', password: '', status: SignupStatus.initial);
  }

  SignupState copyWith(
      {String? email,
      String? password,
      String? username,
      SignupStatus? status}) {
    return SignupState(
        email: email ?? this.email,
        password: password ?? this.password,
        username: username ?? this.username,
        status: status ?? this.status);
  }

  bool get isValid =>
      email.isNotEmpty && password.isNotEmpty && username.isNotEmpty;

  @override
  List<Object> get props => [email, password, username, status];
}
