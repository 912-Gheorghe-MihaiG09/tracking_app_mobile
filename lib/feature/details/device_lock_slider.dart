part of 'device_details_screen.dart';

class _DeviceLockSlider extends StatefulWidget {
  final int initialValueInMeters;
  final Device device;
  const _DeviceLockSlider(
      {required this.device, required this.initialValueInMeters});

  @override
  State<_DeviceLockSlider> createState() => _DeviceLockSliderState();
}

class _DeviceLockSliderState extends State<_DeviceLockSlider> {
  double _ratio = 0;

  int _meters = 0;

  static const _maxMeters = 200;

  @override
  void initState() {
    super.initState();
    _meters = widget.initialValueInMeters;
    _ratio = widget.initialValueInMeters / _maxMeters;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDetailsBloc, DeviceDetailsState>(
      listener: (context, state) {
        if (state is LockDeviceError) {
          GenericDialogs.somethingWentWrong().showOSDialog(context);
        } else if (state is LockDeviceSuccessful) {
          NativeDialog(
                  title: 'Device Locked Successfully',
                  content: 'Device locked successfully, you will be notified '
                      'if this device leaves the marked area!',
                  firstButtonText: 'ok')
              .showOSDialog(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Slider(
                  activeColor: AppColors.secondary,
                  value: _ratio,
                  onChangeEnd: (value) {
                    BlocProvider.of<DeviceDetailsBloc>(context)
                        .add(UpdateLockCircleRadius(newRadius: _meters));
                  },
                  onChanged: (value) {
                    setState(() {
                      _ratio = value;
                      _meters = (_maxMeters * _ratio).floor();
                    });
                  }),
              Text(
                "${_meters}m",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppColors.secondary),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CustomElevatedButton(
                  text: "Save",
                  onPressed: () {
                    BlocProvider.of<DeviceDetailsBloc>(context).add(
                      SaveLock(
                        radius: _meters,
                        location: widget.device.location.location,
                        deviceSerialNumber: widget.device.serialNumber,
                      ),
                    );
                  },
                ),
              ),
              CustomElevatedButton(
                text: "Cancel",
                onPressed: () {
                  BlocProvider.of<DeviceDetailsBloc>(context).add(
                    const ResetState(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
