part of 'userinfo_cubit.dart';

enum UserInfoStatus { initial, submitting, success, error }

class UserInfoState extends Equatable {
  final String age;
  final String location;
  final String sex;
  final UserInfoStatus status;
  const UserInfoState(
      {required this.age,
      required this.sex,
      required this.location,
      required this.status});

  factory UserInfoState.initial() {
    return const UserInfoState(
        age: '', sex: '', location: '', status: UserInfoStatus.initial);
  }

  UserInfoState copyWith(
      {String? age, String? location, String? sex, UserInfoStatus? status}) {
    return UserInfoState(
        age: age ?? this.age,
        location: location ?? this.location,
        sex: sex ?? this.sex,
        status: status ?? this.status);
  }

  bool get isValid => age.isNotEmpty && location.isNotEmpty && sex.isNotEmpty;

  @override
  List<Object> get props => [age, location, sex, status];
}
