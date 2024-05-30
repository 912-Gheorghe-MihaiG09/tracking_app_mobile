import 'dart:async';

import 'package:tracking_app/data/data_source/device/device_data_source.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';

class DeviceRepositoryImpl extends DeviceRepository{
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
  FutureOr<Device?> updateDevice(String serialNumber, String deviceName, DeviceCategory category) {
    return _deviceDataSource.updateDevice(serialNumber, deviceName, category);
  }
}