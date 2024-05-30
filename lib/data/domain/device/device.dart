import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';

class Device {
  final String serialNumber;
  final String? deviceName;
  final DeviceLocation location;
  final List<DeviceLocation> locationHistory;
  final List<LatLng>? zoneBoundaries;
  final DeviceCategory deviceCategory;

  const Device({
    required this.serialNumber,
    this.deviceName,
    required this.location,
    required this.locationHistory,
    this.zoneBoundaries,
    required this.deviceCategory,
  });

  Device copyWith({
    String? serialNumber,
    String? deviceName,
    DeviceLocation? location,
    List<DeviceLocation>? locationHistory,
    List<LatLng>? zoneBoundaries,
    DeviceCategory? deviceCategory,
  }) {
    return Device(
      serialNumber: serialNumber ?? this.serialNumber,
      deviceName: deviceName ?? this.deviceName,
      location: location ?? this.location,
      locationHistory: locationHistory ?? this.locationHistory,
      zoneBoundaries: zoneBoundaries ?? this.zoneBoundaries,
      deviceCategory: deviceCategory ?? this.deviceCategory,
    );
  }

  Map<String, dynamic> toJson() => {
        'serialNumber': serialNumber,
        'deviceName': deviceName,
        'location': location.toJson(),
        'locationHistory': locationHistory.map((e) => e.toJson()).toList(),
        'zoneBoundaries': zoneBoundaries?.map((e) => e.toJson()).toList(),
        'deviceCategory': deviceCategory.name,
      };

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        serialNumber: json['serialNumber'],
        deviceName: json['deviceName'],
        location: DeviceLocation.fromJson(json['location']),
        locationHistory: (json['locationHistory'] as List)
            .map((e) => DeviceLocation.fromJson(e as Map<String, dynamic>))
            .toList(),
        zoneBoundaries: json['zoneBoundaries']
            ?.map((e) => LatLng.fromJson(e as Map<String, dynamic>))
            .toList(),
        deviceCategory:
            DeviceCategory.getDeviceCategory(json['deviceCategory'] ?? ""),
      );

  static List<Device> listFromJson(list) =>
      List<Device>.from(list.map((x) => Device.fromJson(x)));
}

class DeviceLocation {
  final LatLng location;
  final DateTime time;

  const DeviceLocation({required this.location, required this.time});

  DeviceLocation copyWith({LatLng? location, DateTime? time}) {
    return DeviceLocation(
      location: location ?? this.location,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() =>
      {'location': location.toJson(), 'time': time.toIso8601String()};

  factory DeviceLocation.fromJson(Map<String, dynamic> json) => DeviceLocation(
        location: LatLng(json['latitude'], json['longitude']),
        time: DateTime.parse(json['time']),
      );
}
