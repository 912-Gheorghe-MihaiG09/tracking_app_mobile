import 'dart:async';

import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:tracking_app/data/repository/device/data_source/device_data_source.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';

class DeviceRepositoryImpl extends DeviceRepository {
  final DeviceDataSource _deviceDataSource;

  DeviceRepositoryImpl(this._deviceDataSource);

  @override
  FutureOr<Device?> addDevice(String serialNumber) {
    return _deviceDataSource.addDevice(serialNumber);
  }

  @override
  FutureOr<List<Device>> getDevices() {
    return _deviceDataSource.getDevices();
  }

  @override
  FutureOr<void> removeDevice(String serialNumber) {
    return _deviceDataSource.removeDevice(serialNumber);
  }

  @override
  FutureOr<Device?> updateDevice(
      String serialNumber, String deviceName, DeviceCategory category) {
    return _deviceDataSource.updateDevice(serialNumber, deviceName, category);
  }

  @override
  FutureOr<Device?> lockDevice(
      String serialNumber, LatLng location, int radius) {
    return _deviceDataSource.lockDevice(serialNumber, location, radius);
  }

  @override
  FutureOr<Device?> unlockDevice(String serialNumber) {
    return _deviceDataSource.unlockDevice(serialNumber);
  }

  @override
  FutureOr<void> pingDevice(String serialNumber) {
    return _deviceDataSource.pingDevice(serialNumber);
  }

  @override
  Future<Stream?> notificationStream() {
    return _deviceDataSource.notificationStream();
  }
}
