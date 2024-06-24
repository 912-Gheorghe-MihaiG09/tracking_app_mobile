part of 'device_details_bloc.dart';

sealed class DeviceDetailsState extends Equatable {
  final Device device;
  final bool isPinging;

  const DeviceDetailsState({required this.isPinging, required this.device});

  @override
  List<Object> get props => [device, isPinging];

  copyWith({
    Device? device,
    bool? isPinging,
  });
}

final class DeviceDetailsInitial extends DeviceDetailsState {
  const DeviceDetailsInitial({required super.device, required super.isPinging});

  @override
  DeviceDetailsInitial copyWith({Device? device, bool? isPinging}) =>
      DeviceDetailsInitial(
        device: device ?? super.device,
        isPinging: isPinging ?? super.isPinging,
      );
}

final class PingError extends DeviceDetailsState {
  const PingError({required super.isPinging, required super.device});

  @override
  PingError copyWith({Device? device, bool? isPinging}) => PingError(
        device: device ?? super.device,
        isPinging: isPinging ?? super.isPinging,
      );
}

abstract class LockState extends DeviceDetailsState {
  final int lockRadius;

  const LockState(
      {required this.lockRadius,
      required super.device,
      required super.isPinging});

  @override
  List<Object> get props => [lockRadius, ...super.props];
}

final class LockDevice extends LockState {
  const LockDevice(
      {required super.lockRadius,
      required super.device,
      required super.isPinging});

  @override
  LockDevice copyWith({Device? device, bool? isPinging}) => LockDevice(
      device: device ?? super.device,
      isPinging: isPinging ?? super.isPinging,
      lockRadius: lockRadius);
}

final class LockDeviceLoading extends LockState {
  const LockDeviceLoading(
      {required super.lockRadius,
      required super.device,
      required super.isPinging});

  @override
  LockDeviceLoading copyWith({Device? device, bool? isPinging}) =>
      LockDeviceLoading(
          device: device ?? super.device,
          isPinging: isPinging ?? super.isPinging,
          lockRadius: lockRadius);
}

final class LockDeviceSuccessful extends LockState {
  const LockDeviceSuccessful(
      {required super.lockRadius,
      required super.device,
      required super.isPinging});

  @override
  LockDeviceSuccessful copyWith({Device? device, bool? isPinging}) =>
      LockDeviceSuccessful(
          device: device ?? super.device,
          isPinging: isPinging ?? super.isPinging,
          lockRadius: lockRadius);
}

final class LockDeviceError extends LockState {
  const LockDeviceError(
      {required super.lockRadius,
      required super.device,
      required super.isPinging});

  @override
  LockDeviceError copyWith({Device? device, bool? isPinging}) =>
      LockDeviceError(
          device: device ?? super.device,
          isPinging: isPinging ?? super.isPinging,
          lockRadius: lockRadius);
}

abstract class UnlockState extends DeviceDetailsState {
  const UnlockState({required super.device, required super.isPinging});
}

final class UnlockDeviceLoading extends UnlockState {
  const UnlockDeviceLoading({required super.device, required super.isPinging});

  @override
  UnlockDeviceLoading copyWith({Device? device, bool? isPinging}) =>
      UnlockDeviceLoading(
        device: device ?? super.device,
        isPinging: isPinging ?? super.isPinging,
      );
}

final class UnlockDeviceSuccess extends UnlockState {
  const UnlockDeviceSuccess({required super.device, required super.isPinging});

  @override
  UnlockDeviceSuccess copyWith({Device? device, bool? isPinging}) =>
      UnlockDeviceSuccess(
        device: device ?? super.device,
        isPinging: isPinging ?? super.isPinging,
      );
}

final class UnlockDeviceError extends UnlockState {
  const UnlockDeviceError({required super.device, required super.isPinging});

  @override
  UnlockDeviceError copyWith({Device? device, bool? isPinging}) =>
      UnlockDeviceError(
        device: device ?? super.device,
        isPinging: isPinging ?? super.isPinging,
      );
}
