part of 'device_list_bloc.dart';

sealed class DeviceListState extends Equatable {
  const DeviceListState();

  @override
  List<Object> get props => [];
}

final class DeviceListInitial extends DeviceListState {
  const DeviceListInitial();
}

final class DeviceListLoading extends DeviceListState {
  const DeviceListLoading();
}

final class DeviceListLoaded extends DeviceListState {
  final List<Device> devices;

  const DeviceListLoaded({required this.devices});

  @override
  List<Object> get props => [devices];
}

final class DeviceListRefreshing extends DeviceListLoaded {
  const DeviceListRefreshing({required super.devices});
}

final class DeviceListError extends DeviceListState {
  const DeviceListError();
}
