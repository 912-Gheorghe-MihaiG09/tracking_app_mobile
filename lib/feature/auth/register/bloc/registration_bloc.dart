import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/data/domain/user.dart';
import 'package:tracking_app/data/repository/auth/auth_repository.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authRepository;

  RegistrationBloc(this._authRepository) : super(RegistrationInitial()) {
    on<RegistrationButtonPressed>(_onRegistrationButtonPressed);
    on<ResetRegistrationState>(_onResetRegistrationState);
  }

  void _onResetRegistrationState(
      ResetRegistrationState event, Emitter<RegistrationState> emit) async {
    emit(RegistrationInitial());
  }

  FutureOr<void> _onRegistrationButtonPressed(
      RegistrationButtonPressed event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      await _authRepository.registerUser(event.user);
      emit(RegistrationSuccess());
    } catch (e) {
      print(e);
      emit(RegistrationError(
          e.toString(), RegistrationErrorStatus.unknownError));
    }
  }
}
