part of 'device_connectivity_bloc.dart';

sealed class DeviceConnectivityEvent extends Equatable {
  const DeviceConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class PairDevice extends DeviceConnectivityEvent{
  final String serialNumber;

  const PairDevice(this.serialNumber);

  @override
  List<Object?> get props => [serialNumber];
}

class UpdateDevice extends DeviceConnectivityEvent{
  final String deviceName;
  final DeviceCategory deviceCategory;

  const UpdateDevice(this.deviceName, this.deviceCategory);

  @override
  List<Object?> get props => [deviceName];
}


class ResetToInitial extends DeviceConnectivityEvent{
  const ResetToInitial();

  @override
  List<Object?> get props => [];
}
