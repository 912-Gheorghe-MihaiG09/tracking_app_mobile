part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class Authenticated extends AuthState {
  final User account;

  const Authenticated(this.account);

  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}
