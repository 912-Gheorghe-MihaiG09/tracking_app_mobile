import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/common/widgets/text_input_field.dart';
import 'package:tracking_app/feature/connectivity/bloc/device_connectivity_bloc.dart';
import 'package:tracking_app/feature/connectivity/screens/device_naming_screen.dart';

class ManualEntryField extends StatefulWidget {
  final String? secondaryButtonText;
  final Function? secondaryButtonAction;

  const ManualEntryField(
      {super.key, this.secondaryButtonAction, this.secondaryButtonText});

  @override
  State<ManualEntryField> createState() => _ManualEntryFieldState();
}

class _ManualEntryFieldState extends State<ManualEntryField> {
  final _serialNumberController = TextEditingController();
  bool _isButtonEnabled = false;
  TextInputType keyboardType = TextInputType.text;
  String previousText = "";

  @override
  void initState() {
    BlocProvider.of<DeviceConnectivityBloc>(context)
        .add(const ResetToInitial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceConnectivityBloc, DeviceConnectivityState>(
      listenWhen: (previous, current) =>
          ModalRoute.of(context)?.isCurrent ?? false,
      listener: _handleBlocStates,
      builder: (context, state) => state is DeviceConnectivityLoading
          ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Material(
                    color: AppColors.transparent,
                    child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextInputField(
                      labelText: "Device Serial Number",
                      characterLimit: 17,
                      hintText: "000-0000000-00000",
                      keyboardType: keyboardType,
                      textInputAction: TextInputAction.done,
                      autoValidateMode: AutovalidateMode.always,
                      textCapitalization: TextCapitalization.characters,
                      validator: (s) => _validateBatterySerialNumber(s, state),
                      controller: _serialNumberController,
                      onChanged: (value) => setState(() {
                        _textChangeHandler(value);
                      }),
                    ),
                  ),),
                  Column(children: [
                    ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              if (state is DeviceConnectivityLoading) {
                                return;
                              }
                              BlocProvider.of<DeviceConnectivityBloc>(context)
                                  .add(
                                      PairDevice(_serialNumberController.text));
                            }
                          : null,
                      child: const Text("Add New Device"),
                    ),
                    if (widget.secondaryButtonText != null)
                      Center(
                        child: TextButton(
                          onPressed: () => widget.secondaryButtonAction?.call(),
                          child: Text(widget.secondaryButtonText!),
                        ),
                      ),
                  ]),
                ]),
    );
  }

  void _handleBlocStates(BuildContext context, DeviceConnectivityState state) {
    if (state is DeviceConnectivitySuccess) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => BlocProvider.value(
            value: BlocProvider.of<DeviceConnectivityBloc>(context),
            child: const DeviceNamingScreen(),
          ),
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
      );
    }
  }

  String? _validateBatterySerialNumber(
      String? s, DeviceConnectivityState state) {
    if (state is DeviceConnectivityError) {
      switch (state.reason) {
        case DeviceConnectivityErrorReason.doesNotExist:
          return "This serial number is invalid. Please try again";
        case DeviceConnectivityErrorReason.unknown:
          return "Something went wrong, please try again later";
      }
    }
    return null;
  }

  /// Format of a SN is:
  /// ###-#######-#####
  /// VM3-1234567-12345
  /// Where the first 3 characters can be alphanumeric (both letters and numbers)
  /// The following 7 characters only numerical
  /// The last 5 characters only numerical
  void _textChangeHandler(String value) {
    value = value.replaceAll(RegExp(r"[^a-zA-Z0-9]+"), "");
    var currentSelection = _serialNumberController.selection;
    if (value.length >= 3 && value.length < 10) {
      value = "${value.substring(0, 3)}-${value.substring(3, value.length)}";
    } else if (value.length >= 10) {
      value =
          "${value.substring(0, 3)}-${value.substring(3, 10)}-${value.substring(10, value.length)}";
    }

    if (currentSelection.extentOffset >= value.length ||
        currentSelection.end > value.length) {
      _serialNumberController.value = TextEditingValue(
          text: value.toUpperCase(),
          selection: currentSelection.copyWith(
              baseOffset: value.length, extentOffset: value.length));
    } else {
      _serialNumberController.value = TextEditingValue(
          text: value.toUpperCase(), selection: currentSelection);
    }

    /// when the last char is a '-', the last operation is an addition
    if (value.endsWith("-") && value.length > previousText.length) {
      /// and we have a collapsed selection on before the '-'
      if (_serialNumberController.selection.isCollapsed &&
          _serialNumberController.selection.baseOffset == value.length - 1) {
        /// move the selection after the '-'
        _serialNumberController.moveCursorToEnd();
      }
    }
    previousText = value;
    _isButtonEnabled = RegExp(r"^[a-zA-Z0-9]{3}-\d{7}-\d{5}$")
        .hasMatch(_serialNumberController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _serialNumberController.dispose();
  }
}
