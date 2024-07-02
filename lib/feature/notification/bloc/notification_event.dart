part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class _NewNotification extends NotificationEvent {
  final String data;

  const _NewNotification(this.data);
}
