import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/rounded_container.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/feature/connectivity/bloc/device_connectivity_bloc.dart';
import 'package:tracking_app/feature/connectivity/widgets/manual_entry_field.dart';
import 'package:tracking_app/feature/connectivity/widgets/qr_scanner.dart';

class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog({super.key});

  static Future<Object?> showDialog(
    BuildContext context,
  ) {
    return showGeneralDialog(
      barrierLabel: "dismiss",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: BlocProvider(
            create: (_) => DeviceConnectivityBloc(
              RepositoryProvider.of<DeviceRepository>(context),
            ),
            child: const AddDeviceDialog(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  bool _manualEntry = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: RoundedContainer(
            hasAllCornersRounded: true,
            color: AppColors.surface,
            radius: 24,
            child: SingleChildScrollView(
                child: !_manualEntry
                    ? _CameraLayout(
                        onButtonPress: () {
                          setState(() {
                            _manualEntry = true;
                          });
                        },
                      )
                    : _ManualEntryLayout(
                        onButtonPress: () {
                          setState(() {
                            _manualEntry = false;
                          });
                        },
                      )),
          ),
        ),
      ),
    );
  }
}

class _CameraLayout extends StatelessWidget {
  final VoidCallback? onButtonPress;

  const _CameraLayout({this.onButtonPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: CloseButton(),
          ),
          Text(
            "Scan QR code",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(height: 0.75),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "QR code can be found on the back of your device",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: 192,
                width: double.infinity,
                child: QRScanner(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: ElevatedButton(
              onPressed: onButtonPress,
              child: const Text("Manual Entry"),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualEntryLayout extends StatelessWidget {
  final VoidCallback? onButtonPress;

  const _ManualEntryLayout({this.onButtonPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: CloseButton(),
          ),
          Text(
            "Manual Entry",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(height: 0.75),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "QR code can be found on the back of your device",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 192,
              width: double.infinity,
              child: ManualEntryField(
                secondaryButtonText: "Scan QR",
                secondaryButtonAction: onButtonPress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
