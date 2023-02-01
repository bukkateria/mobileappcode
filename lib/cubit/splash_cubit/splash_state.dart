part of 'splash_cubit.dart';

enum SplashStatus {
  onboard,
  signup,
  home,
  vendorHome,
  emailVerified,
  userInfoVerify
}

class SplashState extends Equatable {
  final String userType;
  final String uid;
  final SplashStatus status;
  const SplashState(
      {required this.userType, required this.uid, required this.status});

  factory SplashState.initial() {
    return const SplashState(
        userType: '', uid: '', status: SplashStatus.onboard);
  }

  SplashState copyWith({String? userType, String? uid, SplashStatus? status}) {
    return SplashState(
        userType: userType ?? this.userType,
        uid: uid ?? this.uid,
        status: status ?? this.status);
  }

  bool get isValid => userType.isNotEmpty && uid.isNotEmpty;

  @override
  List<Object> get props => [userType, uid, status];
}
