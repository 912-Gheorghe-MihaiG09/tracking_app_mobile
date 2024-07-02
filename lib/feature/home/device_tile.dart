import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/common/utils/string_formatter.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/feature/details/device_details_screen.dart';

class DeviceTile extends StatefulWidget {
  final Device device;
  final bool hasBorder;
  const DeviceTile({super.key, this.hasBorder = false, required this.device});

  @override
  State<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends State<DeviceTile> {
  String deviceAddress = "";

  @override
  void initState() {
    super.initState();
    placemarkFromCoordinates(widget.device.location.location.latitude,
            widget.device.location.location.longitude)
        .then(
      (value) {
        setState(() {
          Placemark bestAddress = value.first;
          for (var address in value) {
            if (address.name != null) {
              if (bestAddress.name == null ||
                  (address.name!.length > bestAddress.name!.length)) {
                bestAddress = address;
              }
            }
          }
          deviceAddress = (bestAddress.name == null || bestAddress.name!.isEmpty
                  ? "unknown"
                  : bestAddress.name!) +
              (bestAddress.locality != null ? ", ${bestAddress.locality}" : "");
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(DeviceDetailsScreen.route(context, widget.device));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.tertiary,
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              widget.device.deviceCategory.iconPath,
              height: 24,
              width: 24,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.device.deviceName ?? widget.device.serialNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  deviceAddress.length < 30
                      ? deviceAddress
                      : deviceAddress.substring(0, 30),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "last update: ${StringFormatter.getTimePassedString(widget.device.location.date)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.black.withOpacity(0.8)),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
