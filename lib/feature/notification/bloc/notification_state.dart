part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
}

final class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

final class NotificationReceived extends NotificationState {
  final DateTime time;
  final Device device;

  const NotificationReceived({
    required this.time,
    required this.device,
  });

  @override
  List<Object?> get props => [time, device];
}
