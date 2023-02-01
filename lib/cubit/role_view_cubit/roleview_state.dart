part of 'roleview_cubit.dart';

enum RoleViewStatus { initial, submitting, success, error, saved }

class RoleViewState extends Equatable {
  final String userType;
  final String uid;
  final RoleViewStatus status;
  const RoleViewState(
      {required this.userType, required this.uid, required this.status});

  factory RoleViewState.initial() {
    return const RoleViewState(userType: '', uid: '', status: RoleViewStatus.initial);
  }

  RoleViewState copyWith(
      {String? userType, String? uid, RoleViewStatus? status}) {
    return RoleViewState(
        userType: userType ?? this.userType,
        uid: uid ?? this.uid,
        status: status ?? this.status);
  }

  bool get isValid => userType.isNotEmpty && uid.isNotEmpty;

  @override
  List<Object> get props => [userType, uid, status];
}
