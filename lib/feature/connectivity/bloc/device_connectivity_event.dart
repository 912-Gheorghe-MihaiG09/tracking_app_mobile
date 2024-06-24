part of 'device_connectivity_bloc.dart';

sealed class DeviceConnectivityEvent extends Equatable {
  const DeviceConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class PairDevice extends DeviceConnectivityEvent {
  final String serialNumber;

  const PairDevice(this.serialNumber);

  @override
  List<Object?> get props => [serialNumber];
}

class ResetToInitial extends DeviceConnectivityEvent {
  const ResetToInitial();

  @override
  List<Object?> get props => [];
}
