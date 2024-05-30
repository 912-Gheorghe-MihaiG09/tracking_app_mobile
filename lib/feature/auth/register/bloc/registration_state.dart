part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationError extends RegistrationState {
  final String error;
  final RegistrationErrorStatus status;

  RegistrationError(this.error, this.status);

  @override
  List<Object?> get props => [error, status];
}

class RegistrationSuccess extends RegistrationState {
  RegistrationSuccess();

  @override
  List<Object?> get props => [];
}

enum RegistrationErrorStatus {
  userAlreadyExists,
  invalidEmailFormat,
  unknownError,
  networkError
}
