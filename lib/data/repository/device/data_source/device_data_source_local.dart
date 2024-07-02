import 'dart:async';

import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:tracking_app/data/repository/device/data_source/device_data_source.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';

class DeviceDataSourceLocal extends DeviceDataSource {
  List<Map<String, dynamic>> data = _DeviceInitialInMemoryData.data;

  List<int> userDevices = [0, 1, 2, 3];

  @override
  FutureOr<Device?> addDevice(String serialNumber) {
    for (int index in userDevices) {
      if (data[index]["serialNumber"] == serialNumber) {
        return Device.fromJson(data[index]);
      }
    }

    for (Map<String, dynamic> deviceJson in data) {
      if (deviceJson["serialNumber"] == serialNumber) {
        userDevices.add(data.indexOf(deviceJson));
        return Device.fromJson(deviceJson);
      }
    }
    return null;
  }

  @override
  FutureOr<List<Device>> getDevices() {
    List<Map<String, dynamic>> userData = [];
    for (int index = 0; index < data.length; index++) {
      if (userDevices.contains(index)) {
        userData.add(data[index]);
      }
    }
    return Device.listFromJson(userData);
  }

  @override
  FutureOr<void> removeDevice(String serialNumber) {
    for (int index in userDevices) {
      if (data[index]["serialNumber"] == serialNumber) {
        userDevices.remove(index);
      }
    }
  }

  @override
  FutureOr<Device?> updateDevice(
      String serialNumber, String deviceName, DeviceCategory category) {
    for (int index in userDevices) {
      if (data[index]["serialNumber"] == serialNumber) {
        data[index]["deviceName"] = deviceName;
        data[index]["deviceCategory"] = category.name;
        return Device.fromJson(data[index]);
      }
    }
    return null;
  }

  @override
  FutureOr<Device?> lockDevice(
      String serialNumber, LatLng location, int radius) {
    return null;
  }

  @override
  FutureOr<Device?> unlockDevice(String serialNumber) {
    return null;
  }

  @override
  FutureOr<void> pingDevice(String serialNumber) {
    return null;
  }

  @override
  Future<Stream?> notificationStream() async {
    return null;
  }
}

class _DeviceInitialInMemoryData {
  static List<Map<String, dynamic>> data = [
    {
      "serialNumber": "SN1-0000000-00001",
      "deviceName": "Rex",
      "location": {
        "latitude": 46.7749,
        "longitude": 23.5863,
        "time": "2024-03-23T15:53:00+01:00"
      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "PETS"
    },
    {
      "serialNumber": "SN1-0000000-00002",
      "deviceName": "Son's Bike",
      "location": {
        "latitude": 46.7699,
        "longitude": 23.5888,
        "time": "2024-03-23T15:48:00+01:00"
      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "BIKE"
    },
    {
      "serialNumber": "SN1-0000000-00003",
      "deviceName": "Work Bag",
      "location": {
        "latitude": 46.7792,
        "longitude": 23.5837,
        "time": "2024-03-23T14:53:00+01:00"
      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "BACKPACK"
    },
    {
      "serialNumber": "SN1-0000000-00004",
      "deviceName": "Wife SUV",
      "location": {
        "latitude": 46.7715,
        "longitude": 23.5913,
        "time": "2024-03-23T15:58:00+01:00"
      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "CAR"
    }
  ];
}
