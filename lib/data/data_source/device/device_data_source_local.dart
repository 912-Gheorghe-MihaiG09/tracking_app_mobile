import 'dart:async';

import 'package:tracking_app/data/data_source/device/device_data_source.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';

class DeviceDataSourceLocal extends DeviceDataSource{
  List<Map<String, dynamic>> data = _DeviceInitialInMemoryData.data;

  List<int> userDevices = [0];

  @override
  FutureOr<Device?> addDevice(String serialNumber) {
    for(int index in userDevices){
      if(data[index]["serialNumber"] == serialNumber){
        return Device.fromJson(data[index]);
      }
    }

    for(Map<String, dynamic> deviceJson in data){
      if(deviceJson["serialNumber"] == serialNumber){
        userDevices.add(data.indexOf(deviceJson));
        return Device.fromJson(deviceJson);
      }
    }
    return null;
  }

  @override
  FutureOr<List<Device>> getDevices() {
    List<Map<String, dynamic>> userData = [];
    for(int index = 0; index < data.length; index ++){
      if(userDevices.contains(index)){
        userData.add(data[index]);
      }
    }
    return Device.listFromJson(userData);
  }

  @override
  FutureOr<void> removeDevice(String serialNumber){
    for(int index in userDevices){
      if(data[index]["serialNumber"] == serialNumber){
        userDevices.remove(index);
      }
    }
  }

  @override
  FutureOr<Device?> updateDevice(String serialNumber, String deviceName, DeviceCategory category) {
    for(int index in userDevices){
      if(data[index]["serialNumber"] == serialNumber){
        data[index]["deviceName"] = deviceName;
        data[index]["deviceCategory"] = category.name;
        return Device.fromJson(data[index]);
      }
    }
    return null;
  }
}

class _DeviceInitialInMemoryData {
  static List<Map<String, dynamic>> data = [
    {
      "serialNumber": "SN1-0000000-00001",
      "deviceName": "Device 1",
      "location": {
        "latitude": 46.7749,
        "longitude": 23.5863,
        "time": "2024-03-23T15:53:00+01:00"
      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "OTHER"
    },
    {
      "serialNumber": "SN1-0000000-00002",
      "deviceName": "Device 2",
      "location": {
        "latitude": 46.7699,
        "longitude": 23.5888,
        "time": "2024-03-23T15:48:00+01:00"
      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "OTHER"
    },
    {
      "serialNumber": "SN1-0000000-00003",
      "deviceName": "Device 3",
      "location": {
        "latitude": 46.7792,
        "longitude": 23.5837,
        "time": "2024-03-23T14:53:00+01:00"
      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "OTHER"
    },
    {
      "serialNumber": "SN1-0000000-00004",
      "deviceName": "Device 4",
      "location": {
        "latitude": 46.7715,
        "longitude": 23.5913,
        "time": "2024-03-23T15:58:00+01:00"

      },
      "locationHistory": [],
      "zoneBoundaries": null,
      "deviceCategory": "OTHER"
    }
  ];
}