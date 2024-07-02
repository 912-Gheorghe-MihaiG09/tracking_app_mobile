import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/common/utils/validator.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final DeviceRepository _deviceRepository;
  final DeviceListBloc _deviceListBloc;

  List<Device> _pairedDevices = [];

  Map<String, DateTime> receivedNotifications = {};

  NotificationBloc(this._deviceRepository, this._deviceListBloc)
      : super(NotificationInitial()) {
    on<_NewNotification>(_onNewNotification);
    _deviceRepository.notificationStream().then(
          (stream) => stream?.listen(
            (data) => add(_NewNotification(data.toString())),
          ),
        );

    _deviceListBloc.stream.asBroadcastStream().listen((state) {
      if (state is DeviceListLoaded) {
        _pairedDevices = state.devices;
      }
    });
  }

  FutureOr<void> _onNewNotification(
    _NewNotification event,
    Emitter<NotificationState> emit,
  ) {
    log("Data received on websocket ${event.data}");
    if (event.data.length == 31 &&
        event.data.substring(0, 14) == "notification: ") {
      String serialNumber = event.data.substring(14);
      if (Validator.validateBatterySerialNumber(serialNumber) == null) {
        for (Device device in _pairedDevices) {
          if (device.serialNumber == serialNumber) {
            _deviceListBloc.add(const RefreshDevices());
            if (receivedNotifications.containsKey(serialNumber)) {
              if (DateTime.now()
                      .difference(receivedNotifications[serialNumber]!)
                      .inSeconds >
                  300) {
                receivedNotifications[serialNumber] = DateTime.now();
                emit(
                  NotificationReceived(time: DateTime.now(), device: device),
                );
              }
            } else {
              receivedNotifications[serialNumber] = DateTime.now();
              emit(
                NotificationReceived(time: DateTime.now(), device: device),
              );
            }
          }
        }
      }
    }

    _deviceListBloc.add(const FetchDevices());
  }
}
