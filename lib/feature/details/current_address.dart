part of 'device_details_screen.dart';

class _CurrentAddress extends StatefulWidget {
  final Device device;

  const _CurrentAddress({required this.device});

  @override
  State<_CurrentAddress> createState() => _CurrentAddressState();
}

class _CurrentAddressState extends State<_CurrentAddress> {
  String deviceAddress = "";

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        deviceAddress,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
