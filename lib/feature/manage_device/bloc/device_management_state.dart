part of 'device_management_bloc.dart';

sealed class DeviceManagementState extends Equatable {
  const DeviceManagementState();

  @override
  List<Object> get props => [];
}

final class DeviceManagementInitial extends DeviceManagementState {
  const DeviceManagementInitial();
}

///  --- Update Flow ---
///
sealed class DeviceUpdateState extends DeviceManagementState {
  const DeviceUpdateState();
}

final class DeviceUpdateLoading extends DeviceUpdateState {
  const DeviceUpdateLoading();
}

final class DeviceUpdateSuccess extends DeviceUpdateState {
  const DeviceUpdateSuccess();
}

final class DeviceUpdateError extends DeviceUpdateState {
  const DeviceUpdateError();
}

///  --- Unpairing Flow ---

sealed class DeviceUnpairingState extends DeviceManagementState {
  const DeviceUnpairingState();
}

final class DeviceUnpairingLoading extends DeviceUnpairingState {
  const DeviceUnpairingLoading();
}

final class DeviceUnpairingSuccess extends DeviceUnpairingState {
  const DeviceUnpairingSuccess();
}

final class DeviceUnpairingError extends DeviceUnpairingState {
  const DeviceUnpairingError();
}
