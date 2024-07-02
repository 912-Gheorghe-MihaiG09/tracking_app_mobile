import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/network/bloc/network_bloc.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/common/widgets/custom_elevated_button.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/feature/connectivity/add_device_dialog.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/home/device_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<void> _refreshCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceListBloc, DeviceListState>(
        listenWhen: (prev, _) {
          return prev is DeviceListRefreshing;
        },
        listener: (_, __) {
          _refreshCompleter.complete();
          _refreshCompleter = Completer();
        },
        buildWhen: (_, current) => current is! DeviceListRefreshing,
        builder: (context, state) {
          if (state is DeviceListLoaded) {
            if (state.devices.isEmpty) {
              return _emptyListInterface();
            }
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () {
                BlocProvider.of<DeviceListBloc>(context).add(
                  const RefreshDevices(),
                );

                return _refreshCompleter.future;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: state.devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DeviceTile(device: state.devices[index]),
                    );
                  },
                ),
              ),
            );
          }
          if (state is DeviceListLoading) {
            return const CircularProgressIndicator();
          }
          if (state is DeviceListError) {
            return _errorInterface();
          }
          return const CircularProgressIndicator();
        });
  }

  Widget _emptyListInterface() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It looks like your list is empty",
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          CustomElevatedButton(
            text: "Add Device",
            onPressed: () {
              NetworkBloc networkBloc = BlocProvider.of<NetworkBloc>(context);
              if (networkBloc.state is NetworkSuccess) {
                AddDeviceDialog.showDialog(context);
              } else {
                GenericDialogs.networkError().showOSDialog(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _errorInterface() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "There was an error while processing your request",
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          CustomElevatedButton(
            text: "Try Again",
            onPressed: () {
              BlocProvider.of<DeviceListBloc>(context).add(
                const FetchDevices(),
              );
            },
          ),
        ],
      ),
    );
  }
}
