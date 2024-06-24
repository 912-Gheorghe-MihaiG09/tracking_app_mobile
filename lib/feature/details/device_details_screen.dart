import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/common/rounded_container.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/common/widgets/custom_elevated_button.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/feature/details/bloc/device_details_bloc.dart';
import 'package:tracking_app/feature/details/widgets/details_action_button.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/manage_device/delete_device_dialog.dart';
import 'package:tracking_app/feature/manage_device/update_device_screen.dart';

import 'unlock_notifier.dart';

part 'details_map.dart';
part 'device_details_sheet.dart';
part 'device_lock_slider.dart';

part 'current_address.dart';

class DeviceDetailsScreen extends StatefulWidget {
  const DeviceDetailsScreen({super.key});

  static MaterialPageRoute route(BuildContext context, Device device) {
    return MaterialPageRoute(builder: (context) {
      return BlocProvider(
        create: (_) => DeviceDetailsBloc(
            RepositoryProvider.of<DeviceRepository>(context),
            BlocProvider.of<DeviceListBloc>(context),
            device: device),
        child: const DeviceDetailsScreen(),
      );
    });
  }

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return UnlockNotifier(
      child: BlocListener<DeviceDetailsBloc, DeviceDetailsState>(
        listenWhen: (_, current) => current is PingError,
        listener: (context, state) {
          GenericDialogs.somethingWentWrong(
            onButtonPress: () =>
                BlocProvider.of<DeviceDetailsBloc>(context).add(
              const ResetState(),
            ),
          ).showOSDialog(context);
        },
        child: BlocBuilder<DeviceDetailsBloc, DeviceDetailsState>(
          builder: (context, state) => Scaffold(
            extendBodyBehindAppBar: true,
            body: Stack(children: [
              LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  height:
                      constraints.maxHeight * (state is LockState ? 1 : 0.6),
                  child: _DetailsMap(
                    device: state.device,
                    initialPosition: state.device.location.location,
                    markerLocations: [state.device.location.location],
                    markerPath: state.device.deviceCategory.iconPath,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        _buildEditPopupMenu(state.device),
                      ],
                    ),
                  ),
                ),
              ),
              state is LockState
                  ? _DeviceLockSlider(
                      device: state.device,
                      initialValueInMeters: state.lockRadius,
                    )
                  : _DeviceDetailsSheet(
                      device: state.device,
                      isPinging: state.isPinging,
                    ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildEditPopupMenu(Device device) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.edit),
      onSelected: (String result) {
        switch (result) {
          case 'Edit':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UpdateDeviceScreen(device: device),
              ),
            );
            break;
          case 'Remove':
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => DeleteDeviceDialog(device: device),
                opaque: false,
              ),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Edit',
          child: Text('Edit'),
        ),
        const PopupMenuItem<String>(
          value: 'Remove',
          child: Text('Remove'),
        ),
      ],
    );
  }
}
