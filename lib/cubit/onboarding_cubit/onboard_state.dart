part of 'onboard_cubit.dart';

enum OnboardStatus { initial, submitting, success, error }

class OnboardState extends Equatable {
  final String? onboard;
  final OnboardStatus status;
  OnboardState({this.onboard,  required this.status});

  factory OnboardState.initial() {
    return OnboardState( status: OnboardStatus.initial);
  }

  OnboardState copyWith(
      {String? onboard, OnboardStatus? status}) {
    return OnboardState(
        onboard: onboard ?? this.onboard,
        status: status ?? this.status);
  }


  @override
  List<Object> get props => [onboard ?? '', status];
}
