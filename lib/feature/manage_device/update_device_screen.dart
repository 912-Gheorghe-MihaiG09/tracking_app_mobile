import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/common/utils/validator.dart';
import 'package:tracking_app/common/widgets/custom_elevated_button.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/common/widgets/text_input_field.dart';
import 'package:tracking_app/data/domain/device/device.dart';
import 'package:tracking_app/data/domain/device/device_categories.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/feature/connectivity/bloc/device_connectivity_bloc.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/manage_device/bloc/device_management_bloc.dart';

class UpdateDeviceScreen extends StatefulWidget {
  final Device device;

  const UpdateDeviceScreen({super.key, required this.device});

  @override
  State<UpdateDeviceScreen> createState() => _UpdateDeviceScreenState();
}

class _UpdateDeviceScreenState extends State<UpdateDeviceScreen> {
  final _deviceNameController = TextEditingController();
  bool _isButtonEnabled = false;
  final List<DeviceCategory> _categoryList = [
    CarCategory(),
    BackpackCategory(),
    BikeCategory(),
    SuitcaseCategory(),
    PetsCategory(),
    HeadphonesCategory(),
    MotorbikeCategory(),
    UmbrellaCategory(),
    OtherCategory(),
  ];

  DeviceCategory _selectedCategory = OtherCategory();
  DeviceListState? _deviceListState;

  late DeviceManagementBloc bloc =
      DeviceManagementBloc(RepositoryProvider.of<DeviceRepository>(context));

  @override
  void initState() {
    super.initState();

    _deviceNameController.text =
        widget.device.deviceName ?? widget.device.serialNumber;
  }

  @override
  Widget build(BuildContext context) {
    _isButtonEnabled =
        Validator.validateDeviceName(_deviceNameController.text) == null;
    return BlocProvider<DeviceManagementBloc>(
      create: (_) => bloc,
      child: BlocListener<DeviceListBloc, DeviceListState>(
        listener: (context, state) {
          _deviceListState = state;
          if (state is! DeviceListLoading) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        child: BlocConsumer<DeviceManagementBloc, DeviceManagementState>(
            listenWhen: (_, current) => current is DeviceUpdateState,
            listener: (context, state) {
              if (state is DeviceUpdateSuccess) {
                BlocProvider.of<DeviceListBloc>(context)
                    .add(const FetchDevices());
              }
              if (state is DeviceUpdateError) {
                GenericDialogs.somethingWentWrong().showOSDialog(context);
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTextSection(),
                          TextInputField(
                            labelText: "Device Name",
                            hintText: "Ex: Device EDZ 01",
                            enableSpaceKey: true,
                            autoValidateMode: AutovalidateMode.always,
                            textCapitalization: TextCapitalization.sentences,
                            characterLimit: 20,
                            type: TextInputFieldType.clear,
                            controller: _deviceNameController,
                            onChanged: (_) => setState(
                              () {
                                _isButtonEnabled = Validator.validateDeviceName(
                                        _deviceNameController.text) ==
                                    null;
                              },
                            ),
                            validator: (s) => Validator.validateDeviceName(s),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _categoryList.map((e) {
                                  return _CategoryDisplayBox(
                                      e,
                                      e.runtimeType ==
                                          _selectedCategory.runtimeType, () {
                                    setState(() {
                                      _selectedCategory = e;
                                    });
                                  });
                                }).toList()),
                          ),
                          CustomElevatedButton(
                            text: "Done",
                            onPressed: _isButtonEnabled
                                ? () {
                                    if (state is DeviceUpdateLoading ||
                                        (_deviceListState != null &&
                                            _deviceListState
                                                is DeviceListLoading)) {
                                      return;
                                    }
                                    bloc.add(
                                      DeviceUpdate(
                                          widget.device.serialNumber,
                                          _deviceNameController.text,
                                          _selectedCategory),
                                    );
                                  }
                                : null,
                            isLoading: state is DeviceConnectivityLoading ||
                                (_deviceListState != null &&
                                    _deviceListState is DeviceListLoading),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildTextSection() {
    return Column(
      children: [
        Text(
          "New Device Connected",
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Now that you have connected a new device, lets give it a name"
            " and a category",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _deviceNameController.dispose();
  }
}

class _CategoryDisplayBox extends StatelessWidget {
  final bool isSelected;
  final DeviceCategory deviceCategory;
  final VoidCallback onPressed;
  const _CategoryDisplayBox(
      this.deviceCategory, this.isSelected, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 110,
        decoration: BoxDecoration(
          color: AppColors.tertiary,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              deviceCategory.iconPath,
              height: 64,
              width: 64,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                deviceCategory.displayName,
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
