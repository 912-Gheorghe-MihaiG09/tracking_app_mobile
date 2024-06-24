part of 'device_details_screen.dart';

class _DeviceDetailsSheet extends StatefulWidget {
  final Device device;
  final bool isPinging;

  const _DeviceDetailsSheet({
    required this.device,
    required this.isPinging,
  });

  @override
  State<_DeviceDetailsSheet> createState() => _DeviceDetailsSheetState();
}

class _DeviceDetailsSheetState extends State<_DeviceDetailsSheet> {
  String deviceAddress = "";
  @override
  void initState() {
    placemarkFromCoordinates(widget.device.location.location.latitude,
            widget.device.location.location.longitude)
        .then(
      (value) {
        setState(() {
          deviceAddress = (value.first.street ?? "unknown") +
              (value.first.postalCode != null
                  ? ", ${value.first.postalCode}"
                  : "");
        });
      },
    );
    super.initState();
  }

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
          child: SingleChildScrollView(
            controller: controller,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                _sheetHandle(),
                _deviceInfo(),
                Row(
                  children: [
                    DetailsActionButton.animatedActionButton(
                      icon: Icons.volume_up_rounded,
                      text: "Play Sound",
                      onPressed: () {
                        BlocProvider.of<DeviceDetailsBloc>(context).add(
                          PingDevice(widget.device.serialNumber),
                        );
                      },
                      animate: widget.isPinging,
                      color: AppColors.primary,
                      animationColor: Colors.green[900]!,
                    ),
                    const Spacer(),
                    DetailsActionButton.staticActionButton(
                        icon: widget.device.isLocked
                            ? Icons.lock_open_rounded
                            : Icons.lock_outline_rounded,
                        text: widget.device.isLocked ? "Unlock" : "Lock",
                        color: CupertinoColors.inactiveGray,
                        onPressed: () {
                          widget.device.isLocked
                              ? BlocProvider.of<DeviceDetailsBloc>(context).add(
                                  UnlockDevice(widget.device.serialNumber),
                                )
                              : BlocProvider.of<DeviceDetailsBloc>(context).add(
                                  StartLock(
                                    initialRadius:
                                        widget.device.geofence?.radius,
                                  ),
                                );
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _deviceInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.tertiary,
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        ),
        child: Column(
          children: [
            _keyValueDisplay("Name: ",
                widget.device.deviceName ?? widget.device.serialNumber),
            _keyValueDisplay("Serial Number: ", widget.device.serialNumber),
            _keyValueDisplay("Current Location: ", deviceAddress),
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
          Expanded(
            child: Text(
              textAlign: TextAlign.right,
              value,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
