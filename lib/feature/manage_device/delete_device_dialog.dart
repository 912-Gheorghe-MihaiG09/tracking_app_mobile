import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/manage_device/bloc/device_management_bloc.dart';

class DeleteDeviceDialog extends StatelessWidget {
  final Device device;
  const DeleteDeviceDialog({required this.device, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceManagementBloc(
        RepositoryProvider.of<DeviceRepository>(context),
      ),
      child: MultiBlocListener(
        listeners: [
          _deviceListListener(context),
          _deviceManagementListener(),
        ],
        // builder ensures that context used contains DeviceManagementBloc
        child: Builder(builder: (context) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showDeleteUnitDialog(context));
          return Container();
        }),
      ),
    );
  }

  void _showDeleteUnitDialog(BuildContext context) {
    NativeDialog(
      title: "Delete Device",
      content:
          "Are you sure you want to delete this Device? This action is not reversible!",
      firstButtonText: "No",
      onFirstButtonPress: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      secondButtonText: "Yes",
      onSecondButtonPress: () {
        BlocProvider.of<DeviceManagementBloc>(context)
            .add(DeviceUnpair(device.serialNumber));
        Navigator.pop(context);
        NativeDialog(
          title: "Loading",
          content: "Your device is being deleted...",
          isLoadingDialog: true,
        ).showOSDialog(context);
      },
    ).showOSDialog(context);
  }

  BlocListener _deviceManagementListener() {
    return BlocListener<DeviceManagementBloc, DeviceManagementState>(
        listener: (context, state) {
      if (state is DeviceUnpairingSuccess) {
        // if the unpair is successful, fetch the home screen list
        BlocProvider.of<DeviceListBloc>(context).add(const FetchDevices());
      }
      if (state is DeviceUnpairingError) {
        Navigator.pop(context);
        NativeDialog(
                title: "Device couldn't be deleted",
                content:
                    "An error occurred while deleting your device, please try again later!",
                firstButtonText: "Ok")
            .showOSDialog(context);
      }
    });
  }

  BlocListener _deviceListListener(BuildContext context) {
    return BlocListener<DeviceListBloc, DeviceListState>(
        bloc: BlocProvider.of<DeviceListBloc>(context),
        listener: (context, state) {
          /// if the fetch is finished and the unpair is successful then
          /// return to the home screen
          if ((state is DeviceListLoaded || state is DeviceListError) &&
              BlocProvider.of<DeviceManagementBloc>(context).state
                  is DeviceUnpairingSuccess) {
            Navigator.popUntil(context, (route) => route.isFirst);
            NativeDialog(
                    title: "Device deleted!",
                    content: "Device was successfully deleted!",
                    firstButtonText: "ok")
                .showOSDialog(context);
            return;
          }
        });
  }
}
