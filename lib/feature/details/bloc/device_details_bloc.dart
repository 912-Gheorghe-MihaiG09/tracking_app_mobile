import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';

part 'device_details_event.dart';
part 'device_details_state.dart';

class DeviceDetailsBloc extends Bloc<DeviceDetailsEvent, DeviceDetailsState> {
  final DeviceRepository _deviceRepository;
  final DeviceListBloc _deviceListBloc;

  DeviceDetailsBloc(this._deviceRepository, this._deviceListBloc,
      {required Device device})
      : super(DeviceDetailsInitial(device: device, isPinging: false)) {
    on<UpdateLockCircleRadius>(_onUpdateLockCircleRadius);
    on<PingDevice>(_onPingDevice);
    on<StartLock>(_onStartLock);
    on<SaveLock>(_onSaveLock);
    on<ResetState>(_onResetState);
    on<UnlockDevice>(_onUnlockDevice);
  }

  FutureOr<void> _onUpdateLockCircleRadius(
      UpdateLockCircleRadius event, Emitter<DeviceDetailsState> emit) async {
    if (state is! LockDevice) {
      return;
    }
    emit(LockDevice(
        lockRadius: event.newRadius,
        device: state.device,
        isPinging: state.isPinging));
  }

  FutureOr<void> _onStartLock(
      StartLock event, Emitter<DeviceDetailsState> emit) {
    emit(LockDevice(
        lockRadius: event.initialRadius ?? 20,
        device: state.device,
        isPinging: state.isPinging));
  }

  FutureOr<void> _onSaveLock(
      SaveLock event, Emitter<DeviceDetailsState> emit) async {
    if (state is LockState) {
      try {
        emit(
          LockDeviceLoading(
              device: state.device,
              lockRadius: (state as LockState).lockRadius,
              isPinging: state.isPinging),
        );

        Device? device = await _deviceRepository.lockDevice(
          event.deviceSerialNumber,
          event.location,
          event.radius,
        );

        if (device == null) {
          log("$runtimeType, _onSaveLock error: returned device is null");
          emit(LockDeviceError(
              lockRadius: (state as LockState).lockRadius,
              device: state.device,
              isPinging: state.isPinging));
          return;
        }

        emit(
          LockDeviceSuccessful(
            lockRadius: event.radius,
            device: device,
            isPinging: state.isPinging,
          ),
        );

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        _deviceListBloc.add(const FetchDevices());

        add(const ResetState());
      } catch (e) {
        log("$runtimeType, _onSaveLock error: $e");
        emit(
          LockDeviceError(
            lockRadius: (state as LockState).lockRadius,
            device: state.device,
            isPinging: state.isPinging,
          ),
        );
      }
    }
  }

  FutureOr<void> _onResetState(
    ResetState event,
    Emitter<DeviceDetailsState> emit,
  ) {
    emit(
      DeviceDetailsInitial(
        device: state.device,
        isPinging: false,
      ),
    );
  }

  FutureOr<void> _onUnlockDevice(
    UnlockDevice event,
    Emitter<DeviceDetailsState> emit,
  ) async {
    emit(
      UnlockDeviceLoading(
        device: state.device,
        isPinging: state.isPinging,
      ),
    );
    try {
      await Future.delayed(const Duration(seconds: 1));
      Device? device = await _deviceRepository.unlockDevice(
        event.deviceSerialNumber,
      );

      if (device == null) {
        log("$runtimeType, _onUnlockDevice error: returned device is null");
        emit(
          LockDeviceError(
            lockRadius: (state as LockState).lockRadius,
            device: state.device,
            isPinging: state.isPinging,
          ),
        );
        return;
      }

      emit(
        UnlockDeviceSuccess(device: device, isPinging: state.isPinging),
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      _deviceListBloc.add(const FetchDevices());

      add(const ResetState());
    } catch (e) {
      log("$runtimeType, _onUnlockDevice error: $e");
      emit(
        UnlockDeviceError(device: state.device, isPinging: state.isPinging),
      );
    }
  }

  FutureOr<void> _onPingDevice(
      PingDevice event, Emitter<DeviceDetailsState> emit) {
    try {
      _deviceRepository.pingDevice(event.serialNumber);
      emit(
        state.copyWith(isPinging: true),
      );
      Future.delayed(
        const Duration(seconds: 5),
      ).then(
        (_) => add(
          const ResetState(),
        ),
      );
    } catch (e) {
      log("$runtimeType, _onUnlockDevice error: $e");
      emit(
        PingError(device: state.device, isPinging: state.isPinging),
      );
    }
  }
}
