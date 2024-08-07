import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';

part 'device_list_event.dart';
part 'device_list_state.dart';

class DeviceListBloc extends Bloc<DeviceListEvent, DeviceListState> {
  final DeviceRepository _deviceRepository;

  DeviceListBloc(this._deviceRepository) : super(const DeviceListInitial()) {
    on<FetchDevices>(_onFetchDevices);
    on<RefreshDevices>(_onRefreshDevices);
  }

  FutureOr<void> _onFetchDevices(
    FetchDevices event,
    Emitter<DeviceListState> emit,
  ) async {
    emit(const DeviceListLoading());
    try {
      List<Device> devices = await _deviceRepository.getDevices();
      emit(DeviceListLoaded(devices: devices));
    } catch (e) {
      log("$runtimeType _onFetchDevices error: ${e.toString()}");
      emit(const DeviceListError());
    }
  }

  FutureOr<void> _onRefreshDevices(
    RefreshDevices event,
    Emitter<DeviceListState> emit,
  ) async {
    if (state is DeviceListLoaded) {
      emit(
        DeviceListRefreshing(
          devices: (state as DeviceListLoaded).devices,
        ),
      );
      try {
        await Future.delayed(const Duration(seconds: 1));
        List<Device> devices = await _deviceRepository.getDevices();
        emit(DeviceListLoaded(devices: devices));
      } catch (e) {
        log("$runtimeType _onFetchDevices error: ${e.toString()}");
        emit(const DeviceListError());
      }
    }
  }
}
