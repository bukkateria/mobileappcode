part of 'reset_cubit.dart';

enum ResetStatus { initial, submitting, success, error }

class ResetState extends Equatable {
  final String email;
  final ResetStatus status;
  const ResetState({required this.email, required this.status});

  factory ResetState.initial() {
    return ResetState(email: '', status: ResetStatus.initial);
  }

  ResetState copyWith({String? email, String? password, ResetStatus? status}) {
    return ResetState(
        email: email ?? this.email, status: status ?? this.status);
  }

  bool get isValid => email.isNotEmpty;

  @override
  List<Object> get props => [email, status];
}
