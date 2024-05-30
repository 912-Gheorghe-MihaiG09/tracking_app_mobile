import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';

part 'device_connectivity_event.dart';
part 'device_connectivity_state.dart';

class DeviceConnectivityBloc
    extends Bloc<DeviceConnectivityEvent, DeviceConnectivityState> {
  final DeviceRepository _deviceRepository;
  String? serialNumber;

  DeviceConnectivityBloc(this._deviceRepository)
      : super(const DeviceConnectivityInitial()) {
    on<PairDevice>(_onPairDevice);
    on<UpdateDevice>(_onUpdateDevice);
    on<ResetToInitial>(_onResetToInitial);
  }

  FutureOr<void> _onPairDevice(
      PairDevice event, Emitter<DeviceConnectivityState> emit) async {
    emit(const DeviceConnectivityLoading());
    try {
      Device? device = await _deviceRepository.addDevice(event.serialNumber);
      if (device == null) {
        emit(const DeviceConnectivityError(
            DeviceConnectivityErrorReason.doesNotExist));
        return;
      }
      serialNumber = event.serialNumber;
      emit(DeviceConnectivitySuccess(device));
    } catch (e) {
      emit(
        const DeviceConnectivityError(DeviceConnectivityErrorReason.unknown),
      );
    }
  }

  FutureOr<void> _onUpdateDevice(
      UpdateDevice event, Emitter<DeviceConnectivityState> emit) async {
    emit(const DeviceConnectivityLoading());
    if (serialNumber != null) {
      try {
        Device? device = await _deviceRepository.updateDevice(
            serialNumber!, event.deviceName, event.deviceCategory);
        if (device == null) {
          emit(const DeviceConnectivityError(
              DeviceConnectivityErrorReason.doesNotExist));
        }
        emit(const DeviceConnectivityUpdateSuccess());
      } catch (e) {
        emit(
          const DeviceConnectivityError(DeviceConnectivityErrorReason.unknown),
        );
      }
    } else {
      emit(
        const DeviceConnectivityError(DeviceConnectivityErrorReason.unknown),
      );
    }
  }

  FutureOr<void> _onResetToInitial(
      ResetToInitial event, Emitter<DeviceConnectivityState> emit) {
    emit(const DeviceConnectivityInitial());
  }
}
