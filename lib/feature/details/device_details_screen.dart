import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/common/rounded_container.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/data/domain/device/device.dart';

part 'details_map.dart';

part 'current_address.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailsScreen({required this.device, super.key});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: constraints.maxHeight * 0.6,
            child: _DetailsMap(
              initialPosition: widget.device.location.location,
              markerLocations: [widget.device.location.location],
              markerPath: widget.device.deviceCategory.iconPath,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        _DeviceDetailsSheet(device: widget.device),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _DeviceDetailsSheet extends StatefulWidget {
  final Device device;

  const _DeviceDetailsSheet({required this.device});

  @override
  State<_DeviceDetailsSheet> createState() => _DeviceDetailsSheetState();
}

class _DeviceDetailsSheetState extends State<_DeviceDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.8,
      minChildSize: 0.4,
      builder: (context, controller) {
        return RoundedContainer(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Expanded(
            child: SingleChildScrollView(
              controller: controller,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  _sheetHandle(),
                  _deviceInfo(),
                  Row(
                    children: [
                      _actionButton(
                          icon: Icons.volume_up_rounded,
                          label: "Play Sound",
                          action: () {}),
                      const Spacer(),
                      _actionButton(
                          icon: Icons.lock,
                          label: "Lock",
                          buttonColor: CupertinoColors.inactiveGray,
                          action: () {})
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(
      {required IconData icon,
      required String label,
      VoidCallback? action,
      Color? buttonColor}) {
    return InkWell(
      onTap: action,
      child: Container(
        width: 150,
        height: 100.0,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.primary,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
            color: AppColors.tertiary,
            borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Column(
          children: [
            _keyValueDisplay("Name: ",
                widget.device.deviceName ?? widget.device.serialNumber),
            _keyValueDisplay("Serial Number: ", widget.device.serialNumber),
            _keyValueDisplay("Current Location: ", "Unknown"),
            _keyValueDisplay(
                "Category: ", widget.device.deviceCategory.displayName),
          ],
        ),
      ),
    );
  }

  Widget _keyValueDisplay(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _sheetHandle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Container(
        height: 6,
        width: 48,
        decoration: const BoxDecoration(
            color: AppColors.tertiary,
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
    );
  }
}
