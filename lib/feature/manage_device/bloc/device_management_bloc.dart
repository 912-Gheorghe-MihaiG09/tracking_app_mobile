import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';

part 'device_management_event.dart';
part 'device_management_state.dart';

class DeviceManagementBloc
    extends Bloc<DeviceManagementEvent, DeviceManagementState> {
  final DeviceRepository _deviceRepository;

  DeviceManagementBloc(this._deviceRepository)
      : super(const DeviceManagementInitial()) {
    on<DeviceUnpair>(_onDeviceUnpair);
    on<DeviceUpdate>(_onDeviceUpdate);
  }

  FutureOr<void> _onDeviceUnpair(
      DeviceUnpair event, Emitter<DeviceManagementState> emit) async {
    emit(const DeviceUnpairingLoading());
    try {
      await _deviceRepository.removeDevice(event.serialNumber);
      emit(const DeviceUnpairingSuccess());
    } catch (e) {
      log("$runtimeType, _onDeviceUnpair error: $e");
      emit(const DeviceUnpairingError());
    }
  }

  FutureOr<void> _onDeviceUpdate(
      DeviceUpdate event, Emitter<DeviceManagementState> emit) async {
    emit(const DeviceUpdateLoading());
    try {
      Device? device = await _deviceRepository.updateDevice(
          event.serialNumber, event.name, event.category);
      if (device == null) {
        log("$runtimeType. _onDeviceUpdate. Status: error. Message: returned device is null");
        emit(const DeviceUpdateError());
        return;
      }
      emit(const DeviceUpdateSuccess());
    } catch (e) {
      log("$runtimeType. _onDeviceUpdate. Status: error. Message: $e");
      emit(const DeviceUpdateError());
    }
  }
}
