import 'dart:async';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/home/device_tile.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  GoogleMapController? _controller;

  final List<Marker> _markersList = [];

  final CarouselController _carouselController = CarouselController();

  Uint8List? _markerIcon;

  Uint8List? _selectedMarkerIcon;

  int _currentSelected = 0;

  CameraPosition? _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initInitialCameraPosition();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMapLayout();
  }

  Widget _buildMapLayout() {
    return BlocBuilder<DeviceListBloc, DeviceListState>(
        builder: (context, state) {
      List<Device> devices = [];
      if (state is DeviceListLoaded) {
        devices = state.devices;

        /// this happens when a device is deleted after the user entered the details screen
        /// from the map screen
        if (_currentSelected >= devices.length) {
          _currentSelected = 0;
        }
        // _controller is not null if the map was created already
        if (_controller != null) {
          _setMarkers(devices);
        }
      }
      // display ProgressIndicator while _initialCameraPosition is not determined
      if (_initialCameraPosition == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is DeviceListLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition!,
            onMapCreated: (controller) async {
              await _onMapCreated(controller, state, devices);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markersList.toSet(),
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state is DeviceListLoaded)
                      Flexible(flex: 6, child: _fleetSize(devices.length)),
                    Flexible(child: _currentPositionButton()),
                  ],
                ),
              ),
              const Spacer(),
              if (state is DeviceListLoaded && state.devices.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add your first device",
                              style: Theme.of(context).textTheme.titleLarge),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text("Add your first device",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          ElevatedButton(
                            child: Text("Add device"),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (state is DeviceListLoaded && devices.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CarouselSlider.builder(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 0.9,
                        initialPage: _currentSelected,
                        aspectRatio: 3.45,
                        enlargeCenterPage: false,
                        padEnds: true,
                        onPageChanged: (index, reason) {
                          if (reason == CarouselPageChangedReason.manual) {
                            _changeSelected(index);
                            _controller?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: devices[index].location.location,
                                    zoom: 12),
                              ),
                            );
                          }
                        }),
                    itemCount: devices.length,
                    itemBuilder: (context, index, realIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        child: DeviceTile(
                          device: devices[index],
                          hasBorder: (index == _currentSelected),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      );
    });
  }

  void _setMarkers(List<Device> devices) {
    _markersList.clear();
    if (_selectedMarkerIcon == null || _markerIcon == null || devices.isEmpty) {
      return;
    }
    for (int index = 0; index < devices.length; index++) {
      _markersList.add(
        Marker(
            markerId: MarkerId(
                devices[index].deviceName ?? devices[index].serialNumber),
            icon: (index != _currentSelected)
                ? BitmapDescriptor.fromBytes(_markerIcon!)
                : BitmapDescriptor.fromBytes(_selectedMarkerIcon!),
            position: devices[index].location.location,
            onTap: () {
              _onMarkerTap(index);
            }),
      );
    }
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: devices[_currentSelected].location.location, zoom: 17),
      ),
    );
  }

  Widget _fleetSize(int size) {
    if (size == 0) {
      return Container();
    }
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
        color: Colors.white,
      ),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text("You have $size active devices")),
    );
  }

  void _onMarkerTap(int index) {
    if (_currentSelected == index) {
      return;
    }
    _carouselController.animateToPage(index,
        duration: const Duration(milliseconds: 500));
    _changeSelected(index);
  }

  void _changeSelected(int index) {
    if (_selectedMarkerIcon == null || _markerIcon == null) {
      return;
    }
    _markersList[index] = _markersList[index]
        .copyWith(iconParam: BitmapDescriptor.fromBytes(_selectedMarkerIcon!));
    _markersList[_currentSelected] = _markersList[_currentSelected]
        .copyWith(iconParam: BitmapDescriptor.fromBytes(_markerIcon!));
    setState(() {
      _currentSelected = index;
    });
  }


  Future<void> _onMapCreated(GoogleMapController controller,
      DeviceListState state, List<Device> devices) async {
    _controller = controller;
    rootBundle
        .loadString('assets/map/map_style.json')
        .then((value) => _controller?.setMapStyle(value));
    if (mounted) {
      await _initImages();
    }
    if (state is DeviceListLoaded) {
      _setMarkers(devices);
      if (mounted) {
        setState(() {});
      }
    }
  }

  static Future<Uint8List> _getImage(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);

    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _initImages() async {
    // marker size must be dependent on screen size
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _markerIcon = await _getImage(
        "assets/images/map_marker_unselected.png", pixelRatio.round() * 40);
    _selectedMarkerIcon = await _getImage(
        "assets/images/map_marker_selected.png", pixelRatio.round() * 60);
  }

  Widget _currentPositionButton() {
    return IconButton(
      onPressed: () {
        _getUserCurrentLocation().then((value) async {
          CameraPosition currentPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude), zoom: 17);
          _controller?.animateCamera(
            CameraUpdate.newCameraPosition(currentPosition),
          );
        });
      },
      color: Colors.black,
      icon: SvgPicture.asset("assets/images/map_current_location.svg"),
    );
  }

  Future<LatLng> _getUserCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  Future<void> _initInitialCameraPosition() async {
    try {
      Device? device;
      DeviceListState state = BlocProvider.of<DeviceListBloc>(context).state;
      if (state is DeviceListLoaded) {
        List<Device> devices = state.devices;
        if (devices.isNotEmpty) {
          device = devices.first;
        }
      }
      if (device != null) {
        _initialCameraPosition =
            CameraPosition(target: device.location.location, zoom: 17);
      } else {
        _initialCameraPosition =
            CameraPosition(target: await _getUserCurrentLocation(), zoom: 17);
      }
    } catch (e) {
      _initialCameraPosition = const CameraPosition(
          target: LatLng(52.53660639886446, 13.535393049537172), zoom: 17);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _controller = null;
  }
}
