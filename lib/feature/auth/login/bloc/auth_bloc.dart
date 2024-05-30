import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/data/domain/user.dart';
import 'package:tracking_app/data/repository/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(Unauthenticated()) {
    on<LogIn>(_onLogIn);
    on<SignOut>(_onSignOut);
  }

  FutureOr<void> _onLogIn(LogIn event, Emitter<AuthState> emit) async {
    var user = await authRepository.login(event.email, event.password);
    if(user != null) {
      print(user.toString());
      emit(Authenticated(user));
    } else{
      emit(Unauthenticated());
    }
  }

  FutureOr<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await authRepository.signOut();
    emit(Unauthenticated());
  }
}
