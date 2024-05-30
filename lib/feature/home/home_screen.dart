import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/rounded_container.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/home/device_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceListBloc, DeviceListState>(
        builder: (context, state) {
      if (state is DeviceListLoaded) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DeviceTile(device: state.devices[index]),
                );
              },
            ),
        );
      }
      return const CircularProgressIndicator();
    });
  }
}
