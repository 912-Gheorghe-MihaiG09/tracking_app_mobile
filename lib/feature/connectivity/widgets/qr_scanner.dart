import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/feature/connectivity/bloc/device_connectivity_bloc.dart';
import 'package:tracking_app/feature/manage_device/update_device_screen.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCameraLayout();
  }

  Widget _buildCameraLayout() {
    return BlocListener<DeviceConnectivityBloc, DeviceConnectivityState>(
      listenWhen: (previous, current) =>
          ModalRoute.of(context)?.isCurrent ?? false,
      listener: _handleBlocStates,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
    );
  }

  void _showDialog(String title, String content) {
    NativeDialog(
      title: title,
      content: content,
      firstButtonText: "OK",
      onFirstButtonPress: () {
        Navigator.pop(context);
        setState(() {
          _isLoading = false;
        });
      },
    ).showOSDialog(context);
    setState(() {
      _isLoading = false;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    //This is added to fix an issue in the package
    //on Android when camera is open, at first shows a black screen
    if (Platform.isAndroid) {
      _controller?.resumeCamera();
    }
    _controller?.scannedDataStream.listen((scanData) {
      String? code = scanData.code;
      // ModalRoute.of(context)?.isCurrent == true -> this checks if a dialog is on top of the camera
      // when a dialog is on top of the camera the scanning should stop
      if (code != null &&
          !_isLoading &&
          ModalRoute.of(context)?.isCurrent == true) {
        BlocProvider.of<DeviceConnectivityBloc>(context).add(PairDevice(code));
      }
    });
  }

  void _navigateToNamingScreen(BuildContext context, Device device) {
    _controller?.pauseCamera();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => UpdateDeviceScreen(device: device),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    ).then((value) {
      _controller?.resumeCamera();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _handleBlocStates(BuildContext context, DeviceConnectivityState state) {
    if (state is DeviceConnectivityLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is DeviceConnectivityError) {
      switch (state.reason) {
        case DeviceConnectivityErrorReason.doesNotExist:
          _showDialog("Invalid Serial Number",
              "You have scanned an invalid serial number. Please try again");
        case DeviceConnectivityErrorReason.unknown:
          _showDialog("Ooops", "Something went wrong, please try again later");
      }
    } else if (state is DeviceConnectivitySuccess) {
      _navigateToNamingScreen(context, state.device);
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    }
    _controller?.resumeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
