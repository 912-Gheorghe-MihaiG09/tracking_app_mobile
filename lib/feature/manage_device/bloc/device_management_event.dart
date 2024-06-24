part of 'device_management_bloc.dart';

sealed class DeviceManagementEvent extends Equatable {
  const DeviceManagementEvent();

  @override
  List<Object?> get props => [];
}

class DeviceUnpair extends DeviceManagementEvent {
  final String serialNumber;

  const DeviceUnpair(this.serialNumber);

  @override
  List<Object> get props => [serialNumber];
}

class DeviceUpdate extends DeviceManagementEvent {
  final String serialNumber;
  final String name;
  final DeviceCategory category;

  const DeviceUpdate(this.serialNumber, this.name, this.category);

  @override
  List<Object> get props => [serialNumber, name, category];
}
