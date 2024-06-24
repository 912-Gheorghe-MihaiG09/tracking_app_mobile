import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';

import 'api_service.dart';

class DeviceService extends ApiService {
  static const String _baseUserUrl = "/api/user";

  DeviceService(super.dio, super.authInterceptor, {required super.baseUrl});

  Future<List<Device>> getAllDevices() async {
    var response = await dio.get(
      "$_baseUserUrl/device",
    );

    return Device.listFromJson(response.data);
  }

  Future<Device> pairDevice(String serialNumber) async {
    var response = await dio.post(
      "$_baseUserUrl/device/pair/$serialNumber",
    );

    return Device.fromJson(response.data);
  }

  Future<void> unpairDevice(String serialNumber) async {
    var response = await dio.post(
      "$_baseUserUrl/device/unpair/$serialNumber",
    );

    return;
  }

  Future<Device> lockDevice(
      String serialNumber, LatLng location, int radius) async {
    var response = await dio.post(
      "$_baseUserUrl/device/lock/$serialNumber",
      data: {
        "latitude": location.latitude,
        "longitude": location.longitude,
        "radius": radius,
      },
    );

    return Device.fromJson(response.data);
  }

  Future<Device> updateDevice(
      String serialNumber, String? name, DeviceCategory? category) async {
    var response = await dio.post(
      "$_baseUserUrl/device/update/$serialNumber",
      data: {
        "name": name,
        "category": category?.name,
      },
    );

    return Device.fromJson(response.data);
  }

  Future<Device?> unlockDevice(String serialNumber) async {
    var response = await dio.post(
      "$_baseUserUrl/device/unlock/$serialNumber",
    );

    return Device.fromJson(response.data);
  }

  Future<void> pingDevice(String serialNumber) async {
    var response = await dio.post("$_baseUserUrl/device/ping/$serialNumber");

    return;
  }
}
