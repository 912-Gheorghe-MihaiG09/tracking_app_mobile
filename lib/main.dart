import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app_settings.dart';
import 'package:tracking_app/common/network/bloc/network_bloc.dart';
import 'package:tracking_app/common/theme/theme_builder.dart';
import 'package:tracking_app/data/data_source/device/device_data_source_local.dart';
import 'package:tracking_app/data/repository/auth/auth_repository.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/data/repository/device/device_repository_impl.dart';
import 'package:tracking_app/data/repository/secure_local_storage.dart';
import 'package:tracking_app/data/service/auth_service.dart';
import 'package:tracking_app/feature/auth/login/bloc/auth_bloc.dart';
import 'package:tracking_app/feature/auth/register/bloc/registration_bloc.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/home/home_screen.dart';
import 'package:tracking_app/feature/root_screen.dart';
import 'package:tracking_app/feature/welcome_screen.dart';

void main() {
  runApp(MyApp(appSettings: AppSettings(baseUrl: 'http://localhost:8080')));
}

class MyApp extends StatelessWidget {
  final AppSettings appSettings;

  MyApp({required this.appSettings, super.key});

  late final DeviceRepository _deviceRepository =
      DeviceRepositoryImpl(DeviceDataSourceLocal());

  late final AuthRepository _authRepository =
  AuthRepository(SecureLocalStorage(), AuthService(baseUrl: appSettings.baseUrl));

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DeviceRepository>(
          create: (_) => _deviceRepository,
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RegistrationBloc(_authRepository)),
          BlocProvider(create: (_) => AuthBloc(_authRepository)),
          BlocProvider(
            create: (_) =>
                DeviceListBloc(_deviceRepository)..add(const FetchDevices()),
          ),
          BlocProvider(
            lazy: false,
            create: (_) => NetworkBloc()..add(NetworkObserve()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeBuilder.getThemeData(true),
          home: BlocConsumer<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const RootScreen();
                } else {
                  return const WelcomeScreen();
                }
              },
              listener: (BuildContext context, AuthState state) =>
                  Navigator.popUntil(context, (route) => route.isFirst)),
        ),
      ),
    );
  }
}
