part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegistrationButtonPressed extends RegistrationEvent {
  final User user;

  RegistrationButtonPressed(this.user);

  @override
  List<Object> get props => [user];
}

class ResetRegistrationState extends RegistrationEvent {}