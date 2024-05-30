import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/common/network/bloc/network_bloc.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/feature/connectivity/add_device_dialog.dart';
import 'package:tracking_app/feature/home/home_screen.dart';
import 'package:tracking_app/feature/map/map_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const HomeScreen(),
    const MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text("James Bond App"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.accent,
            height: 1,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildNavigationBar(),
      floatingActionButton: _selectedIndex == 0 ? _buildAddDeviceButton() : null,
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.accent)),
      ),
      child: NavigationBar(
        overlayColor:
            MaterialStatePropertyAll(AppColors.accent.withOpacity(0.5)),
        destinations: [
          NavigationDestination(
              selectedIcon: SvgPicture.asset(
                "assets/images/navbar/navbar_home_selected_icon.svg",
              ),
              icon: SvgPicture.asset(
                "assets/images/navbar/navbar_home_icon.svg",
              ),
              label: "Home"),
          NavigationDestination(
              selectedIcon: SvgPicture.asset(
                "assets/images/navbar/navbar_map_selected_icon.svg",
              ),
              icon: SvgPicture.asset(
                "assets/images/navbar/navbar_map_icon.svg",
              ),
              label: "Map"),
          NavigationDestination(
              selectedIcon: SvgPicture.asset(
                "assets/images/navbar/navbar_settings_selected_icon.svg",
              ),
              icon: SvgPicture.asset(
                "assets/images/navbar/navbar_settings_icon.svg",
              ),
              label: "Settings")
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildAddDeviceButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        NetworkBloc networkBloc = BlocProvider.of<NetworkBloc>(context);
        if (networkBloc.state is NetworkSuccess) {
          AddDeviceDialog.showDialog(context);
        } else {
          GenericDialogs.networkError().showOSDialog(context);
        }
      },
      label: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.add_rounded),
          Text("Add Device"),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index != 2) {
        _selectedIndex = index;
      }
    });
  }
}
