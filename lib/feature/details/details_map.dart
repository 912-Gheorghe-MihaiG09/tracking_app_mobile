part of 'device_details_screen.dart';

class _DetailsMap extends StatefulWidget {
  final LatLng initialPosition;
  final List<LatLng> markerLocations;
  final String markerPath;
  final Device device;

  const _DetailsMap(
      {required this.initialPosition,
      required this.markerLocations,
      required this.device,
      required this.markerPath});

  @override
  State<_DetailsMap> createState() => _DetailsMapState();
}

class _DetailsMapState extends State<_DetailsMap> {
  GoogleMapController? _controller;
  Uint8List? _markerIcon;

  Uint8List? _selectedMarkerIcon;

  int _currentSelected = 0;

  final List<Marker> _markersList = [];

  final List<Circle> _circleList = [];

  @override
  void initState() {
    super.initState();
    _setupCircle();
  }

  void _setupCircle() {
    _circleList.clear();
    if (widget.device.isLocked) {
      if (widget.device.geofence != null) {
        _circleList.add(
          Circle(
            circleId: const CircleId("Lock circle"),
            center: LatLng(widget.device.geofence!.latitude,
                widget.device.geofence!.longitude),
            radius: widget.device.geofence!.radius.toDouble(),
            fillColor: AppColors.secondary.withOpacity(0.5),
            strokeWidth: 1,
            strokeColor: AppColors.secondary,
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDetailsBloc, DeviceDetailsState>(
      listener: (context, state) {
        if (state is LockState) {
          _circleList.clear();
          _circleList.add(
            Circle(
              circleId: const CircleId("Lock circle"),
              center: widget.initialPosition,
              radius: state.lockRadius.toDouble(),
              fillColor: AppColors.secondary.withOpacity(0.5),
              strokeWidth: 1,
              strokeColor: AppColors.secondary,
            ),
          );
          setState(() {});
        } else {
          _setupCircle();
        }
      },
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: widget.initialPosition, zoom: 18),
        onMapCreated: (controller) async {
          _controller = controller;
          rootBundle
              .loadString('assets/map/map_style.json')
              .then((value) => _controller?.setMapStyle(value));
          if (mounted) {
            await _initImages();
          }

          _setMarkers();
        },
        circles: _circleList.toSet(),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        markers: _markersList.toSet(),
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
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
    _markerIcon = await _getImage(widget.markerPath, pixelRatio.round() * 30);
    _selectedMarkerIcon =
        await _getImage(widget.markerPath, pixelRatio.round() * 30);
  }

  void _setMarkers() {
    _markersList.clear();
    if (_selectedMarkerIcon == null ||
        _markerIcon == null ||
        widget.markerLocations.isEmpty) {
      return;
    }
    for (int index = 0; index < widget.markerLocations.length; index++) {
      _markersList.add(
        Marker(
            markerId: MarkerId(index.toString()),
            icon: (index != _currentSelected)
                ? BitmapDescriptor.fromBytes(_markerIcon!)
                : BitmapDescriptor.fromBytes(_selectedMarkerIcon!),
            position: widget.markerLocations[index],
            onTap: () {
              _onMarkerTap(index);
            }),
      );
    }
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: widget.markerLocations[_currentSelected], zoom: 17),
      ),
    );
    setState(() {});
  }

  void _onMarkerTap(int index) {
    if (_currentSelected == index) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: widget.markerLocations[_currentSelected], zoom: 17),
        ),
      );
      return;
    }
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
}
