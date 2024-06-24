part of 'device_details_bloc.dart';

sealed class DeviceDetailsEvent extends Equatable {
  const DeviceDetailsEvent();

  @override
  List<Object?> get props => [];
}

class StartLock extends DeviceDetailsEvent {
  final int? initialRadius;

  const StartLock({this.initialRadius});

  @override
  List<Object?> get props => [initialRadius];
}

class UpdateLockCircleRadius extends DeviceDetailsEvent {
  final int newRadius;

  const UpdateLockCircleRadius({required this.newRadius});

  @override
  List<Object?> get props => [newRadius];
}

class SaveLock extends DeviceDetailsEvent {
  final int radius;
  final LatLng location;
  final String deviceSerialNumber;

  const SaveLock(
      {required this.radius,
      required this.location,
      required this.deviceSerialNumber});

  @override
  List<Object?> get props => [radius, deviceSerialNumber, location];
}

class ResetState extends DeviceDetailsEvent {
  const ResetState();
}

class UnlockDevice extends DeviceDetailsEvent {
  final String deviceSerialNumber;

  const UnlockDevice(this.deviceSerialNumber);
}

class PingDevice extends DeviceDetailsEvent {
  final String serialNumber;
  const PingDevice(this.serialNumber);
}

class StopPing extends DeviceDetailsEvent {
  const StopPing();
}
