part of 'device_list_bloc.dart';

abstract class DeviceListEvent extends Equatable {
  const DeviceListEvent();

  @override
  List<Object?> get props => [];
}

class FetchDevices extends DeviceListEvent {
  const FetchDevices();
}

class RefreshDevices extends DeviceListEvent {
  const RefreshDevices();
}
