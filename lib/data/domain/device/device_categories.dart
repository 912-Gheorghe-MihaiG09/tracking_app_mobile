import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:tracking_app/common/utils/marker_builder.dart';

abstract class DeviceCategory {
  String get iconPath;
  String get name;
  String get displayName;

  factory DeviceCategory.getDeviceCategory(String deviceCategory) {
    if (deviceCategory == "BIKE") return BikeCategory();
    if (deviceCategory == "CAR") return CarCategory();
    if (deviceCategory == "BACKPACK") return BackpackCategory();
    if (deviceCategory == "HEADPHONES") return HeadphonesCategory();
    if (deviceCategory == "MOTORBIKE") return MotorbikeCategory();
    if (deviceCategory == "PETS") return PetsCategory();
    if (deviceCategory == "SUITCASE") return SuitcaseCategory();
    if (deviceCategory == "UMBRELLA") return UmbrellaCategory();
    if (deviceCategory == "OTHER") return OtherCategory();
    return OtherCategory();
  }

  static Future<Map<String, Uint8List>> categoryMarkers(
      BuildContext context) async {
    int iconSize = MediaQuery.of(context).devicePixelRatio.round() * 30;
    return {
      "BIKE": await MarkerBuilder.getImage(
          "assets/images/category_icons/bike.png", iconSize),
      "CAR": await MarkerBuilder.getImage(
          "assets/images/category_icons/car.png", iconSize),
      "BACKPACK": await MarkerBuilder.getImage(
          "assets/images/category_icons/backpack.png", iconSize),
      "HEADPHONES": await MarkerBuilder.getImage(
          "assets/images/category_icons/headphones.png", iconSize),
      "MOTORBIKE": await MarkerBuilder.getImage(
          "assets/images/category_icons/motorbike.png", iconSize),
      "PETS": await MarkerBuilder.getImage(
          "assets/images/category_icons/pets.png", iconSize),
      "SUITCASE": await MarkerBuilder.getImage(
          "assets/images/category_icons/suitcase.png", iconSize),
      "UMBRELLA": await MarkerBuilder.getImage(
          "assets/images/category_icons/umbrella.png", iconSize),
      "OTHER": await MarkerBuilder.getImage(
          "assets/images/category_icons/other.png", iconSize),
    };
  }
}

class BikeCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/bike.png";

  @override
  String get name => "BIKE";

  @override
  String get displayName => "Bike";
}

class CarCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/car.png";

  @override
  String get name => "CAR";

  @override
  String get displayName => "Car";
}

class BackpackCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/backpack.png";

  @override
  String get name => "BACKPACK";

  @override
  String get displayName => "Backpack";
}

class HeadphonesCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/headphones.png";

  @override
  String get name => "HEADPHONES";

  @override
  String get displayName => "Headphones";
}

class MotorbikeCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/motorbike.png";

  @override
  String get name => "MOTORBIKE";

  @override
  String get displayName => "Motorbike";
}

class PetsCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/pets.png";

  @override
  String get name => "PETS";

  @override
  String get displayName => "Pets";
}

class SuitcaseCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/suitcase.png";

  @override
  String get name => "SUITCASE";

  @override
  String get displayName => "Suitcase";
}

class UmbrellaCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/umbrella.png";

  @override
  String get name => "UMBRELLA";

  @override
  String get displayName => "Umbrella";
}

class OtherCategory implements DeviceCategory {
  @override
  String get iconPath => "assets/images/category_icons/other.png";

  @override
  String get name => "OTHER";

  @override
  String get displayName => "Other";
}
