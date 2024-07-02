import 'dart:async';

import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';
import 'package:tracking_app/data/repository/device/data_source/device_data_source.dart';
import 'package:tracking_app/data/service/device_service.dart';

class DeviceDataSourceRemote extends DeviceDataSource {
  final DeviceService _service;

  DeviceDataSourceRemote(this._service);

  @override
  FutureOr<Device?> addDevice(String serialNumber) {
    return _service.pairDevice(serialNumber);
  }

  @override
  FutureOr<List<Device>> getDevices() {
    return _service.getAllDevices();
  }

  @override
  FutureOr<void> removeDevice(String serialNumber) {
    return _service.unpairDevice(serialNumber);
  }

  @override
  FutureOr<Device?> updateDevice(
      String serialNumber, String deviceName, DeviceCategory category) {
    return _service.updateDevice(serialNumber, deviceName, category);
  }

  @override
  FutureOr<Device?> lockDevice(
      String serialNumber, LatLng location, int radius) {
    return _service.lockDevice(serialNumber, location, radius);
  }

  @override
  FutureOr<Device?> unlockDevice(String serialNumber) {
    return _service.unlockDevice(serialNumber);
  }

  @override
  FutureOr<void> pingDevice(String serialNumber) {
    return _service.pingDevice(serialNumber);
  }

  @override
  Future<Stream?> notificationStream() {
    return _service.connectToDeviceWS();
  }
}
