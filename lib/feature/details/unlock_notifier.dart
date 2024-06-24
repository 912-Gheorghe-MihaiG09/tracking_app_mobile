import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/feature/details/bloc/device_details_bloc.dart';

class UnlockNotifier extends StatelessWidget {
  final Widget? child;

  const UnlockNotifier({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDetailsBloc, DeviceDetailsState>(
      listenWhen: (_, current) => current is UnlockState,
      listener: (context, state) {
        if (state is UnlockDeviceLoading) {
          NativeDialog(
            title: 'Unlocking Device',
            content: 'Please hang on while we are unlocking your device',
            isLoadingDialog: true,
          ).showOSDialog(context);
        }
        if (state is UnlockDeviceSuccess) {
          Navigator.of(context).pop();
          NativeDialog(
            title: 'Device Unlocked Successfully',
            content: 'Your device was unlocked successfully!',
            firstButtonText: "ok",
          ).showOSDialog(context);
        }
        if (state is UnlockDeviceError) {
          Navigator.of(context).pop();
          NativeDialog(
            title: 'Device Unlocked Error',
            content: 'There has been an error while trying to unlock '
                'this device, please try again later',
            firstButtonText: "ok",
          ).showOSDialog(context);
        }
      },
      child: child,
    );
  }
}
