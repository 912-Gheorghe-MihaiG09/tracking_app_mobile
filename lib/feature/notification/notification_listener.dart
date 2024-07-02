import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/feature/notification/bloc/notification_bloc.dart';
import 'package:tracking_app/feature/notification/notification_service.dart';

class NotificationListener extends StatelessWidget {
  final Widget child;
  const NotificationListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        print(state);
        if (state is NotificationReceived) {
          NotificationService.instance.showNotification(
              id: 0,
              title: "Device left designated area!",
              body: "${state.device.deviceName ?? state.device.serialNumber}"
                  " has left their designated area, make just it was not stolen");
        }
      },
      child: child,
    );
  }
}
