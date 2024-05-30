import 'dart:async';

import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';

abstract class DeviceRepository{
  FutureOr<Device?> addDevice(String serialNumber);

  FutureOr<List<Device>> getDevices();

  FutureOr<Device?> updateDevice(String serialNumber, String deviceName, DeviceCategory category);

  FutureOr<void> removeDevice(String serialNumber);
}