part of 'device_connectivity_bloc.dart';

sealed class DeviceConnectivityState extends Equatable {
  const DeviceConnectivityState();

  @override
  List<Object> get props => [];
}

class DeviceConnectivityInitial extends DeviceConnectivityState {
  const DeviceConnectivityInitial();
}

class DeviceConnectivityLoading extends DeviceConnectivityState {
  const DeviceConnectivityLoading();
}

class DeviceConnectivitySuccess extends DeviceConnectivityState {
  final Device device;

  const DeviceConnectivitySuccess(this.device);

  @override
  List<Object> get props => [device];
}


class DeviceConnectivityUpdateSuccess extends DeviceConnectivityState {
  const DeviceConnectivityUpdateSuccess();
}

class DeviceConnectivityError extends DeviceConnectivityState {
  final DeviceConnectivityErrorReason reason;

  const DeviceConnectivityError(this.reason);

  @override
  List<Object> get props => [reason];
}

enum DeviceConnectivityErrorReason {
  doesNotExist,
  unknown
}
