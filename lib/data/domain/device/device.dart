import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';

class Device {
  final String serialNumber;
  final String? deviceName;
  final DeviceLocation location;
  final List<DeviceLocation> locationHistory;
  final DeviceCategory deviceCategory;
  final bool isLocked;
  final Geofence? geofence;

  const Device({
    required this.serialNumber,
    this.deviceName,
    required this.location,
    required this.locationHistory,
    required this.deviceCategory,
    this.geofence,
    this.isLocked = false,
  });

  Device copyWith({
    String? serialNumber,
    String? deviceName,
    DeviceLocation? location,
    List<DeviceLocation>? locationHistory,
    List<LatLng>? zoneBoundaries,
    DeviceCategory? deviceCategory,
    bool? isLocked,
  }) {
    return Device(
        serialNumber: serialNumber ?? this.serialNumber,
        deviceName: deviceName ?? this.deviceName,
        location: location ?? this.location,
        locationHistory: locationHistory ?? this.locationHistory,
        deviceCategory: deviceCategory ?? this.deviceCategory,
        isLocked: isLocked ?? this.isLocked);
  }

  Map<String, dynamic> toJson() => {
        'serialNumber': serialNumber,
        'deviceName': deviceName,
        'location': location.toJson(),
        'locationHistory': locationHistory.map((e) => e.toJson()).toList(),
        'geofence': geofence?.toJson(),
        'deviceCategory': deviceCategory.name,
        'isLocked': isLocked,
      };

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        serialNumber: json['serialNumber'],
        deviceName: json['name'],
        isLocked: json['isLocked'] ?? false,
        location: json['location'] != null
            ? DeviceLocation.fromJson(json['location'])
            : DeviceLocation.defaultLocation,
        locationHistory: (json['locationHistory'] as List)
            .map((e) => DeviceLocation.fromJson(e as Map<String, dynamic>))
            .toList(),
        geofence: json['geofence'] != null
            ? Geofence.fromJson(json['geofence'])
            : null,
        deviceCategory:
            DeviceCategory.getDeviceCategory(json['category'] ?? ""),
      );

  static List<Device> listFromJson(list) =>
      List<Device>.from(list.map((x) => Device.fromJson(x)));
}

class DeviceLocation {
  final LatLng location;
  final DateTime date;

  const DeviceLocation({required this.location, required this.date});

  DeviceLocation copyWith({LatLng? location, DateTime? date}) {
    return DeviceLocation(
      location: location ?? this.location,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() =>
      {'location': location.toJson(), 'date': date.toIso8601String()};

  factory DeviceLocation.fromJson(Map<String, dynamic> json) => DeviceLocation(
        location: LatLng(json['latitude'], json['longitude']),
        date: DateTime.parse(json['date']).toLocal(),
      );

  static DeviceLocation defaultLocation =
      DeviceLocation(location: const LatLng(0, 0), date: DateTime(2024));
}

class Geofence {
  final double latitude;
  final double longitude;
  final int radius;

  Geofence({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory Geofence.fromJson(Map<String, dynamic> json) => Geofence(
        latitude: json["latitude"],
        longitude: json["longitude"],
        radius: (json["radius"] as double).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      };
}
