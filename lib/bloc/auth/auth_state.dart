part of 'auth_bloc.dart';

enum AuthStatus { guest, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final auth.User? user;

  AuthState._({this.status = AuthStatus.guest, this.user,});

  AuthState.guest() :  this._();
  AuthState.authenticated({ required auth.User user}) : this._(
      status: AuthStatus.authenticated,
      user: user,
  );
  AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);


  @override
  List<Object?> get props => [status, user];
}
