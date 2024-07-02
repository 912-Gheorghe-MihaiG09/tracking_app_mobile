import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';

abstract class DeviceRepository {
  FutureOr<Device?> addDevice(String serialNumber);

  FutureOr<List<Device>> getDevices();

  FutureOr<Device?> updateDevice(
      String serialNumber, String deviceName, DeviceCategory category);

  FutureOr<void> removeDevice(String serialNumber);

  FutureOr<Device?> lockDevice(
      String serialNumber, LatLng location, int radius);

  FutureOr<Device?> unlockDevice(String serialNumber);

  FutureOr<void> pingDevice(String serialNumber);

  Future<Stream<dynamic>?> notificationStream();
}
