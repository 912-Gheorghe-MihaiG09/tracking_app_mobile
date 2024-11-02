import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app_settings.dart';
import 'package:tracking_app/common/network/bloc/network_bloc.dart';
import 'package:tracking_app/common/theme/theme_builder.dart';
import 'package:tracking_app/data/repository/auth/auth_repository.dart';
import 'package:tracking_app/data/repository/device/data_source/device_data_source_local.dart';
import 'package:tracking_app/data/repository/device/data_source/device_data_source_remote.dart';
import 'package:tracking_app/data/repository/device/device_repository.dart';
import 'package:tracking_app/data/repository/device/device_repository_impl.dart';
import 'package:tracking_app/data/repository/secure_local_storage.dart';
import 'package:tracking_app/data/service/auth_service.dart';
import 'package:tracking_app/data/service/device_service.dart';
import 'package:tracking_app/data/service/interceptors/auth_interceptor.dart';
import 'package:tracking_app/feature/auth/login/bloc/auth_bloc.dart';
import 'package:tracking_app/feature/auth/register/bloc/registration_bloc.dart';
import 'package:tracking_app/feature/home/bloc/device_list_bloc.dart';
import 'package:tracking_app/feature/notification/bloc/notification_bloc.dart';
import 'package:tracking_app/feature/notification/notification_service.dart';
import 'package:tracking_app/feature/root_screen.dart';
import 'package:tracking_app/feature/welcome_screen.dart';
import 'package:tracking_app/feature/notification/notification_listener.dart'
    as nl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.initNotification();

  runApp(
    MyApp(
      appSettings: AppSettings(baseUrl: 'http://34.89.169.41:8080'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppSettings appSettings;

  MyApp({required this.appSettings, super.key});

  final Dio _dio = Dio();

  late final AuthInterceptor authInterceptor =
      AuthInterceptor(_dio, SecureLocalStorage(), _authService, () {});

  late final DeviceRepository _deviceRepository = DeviceRepositoryImpl(
      DeviceDataSourceLocal()
      // DeviceDataSourceRemote(
      //   DeviceService(_dio, authInterceptor, baseUrl: appSettings.baseUrl),
      // ),
      );

  late final _authService = AuthService(baseUrl: appSettings.baseUrl);

  late final DeviceListBloc _deviceListBloc = DeviceListBloc(_deviceRepository);

  late final AuthRepository _authRepository =
      AuthRepository(SecureLocalStorage(), _authService);

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
            create: (_) => _deviceListBloc..add(const FetchDevices()),
          ),
          BlocProvider(
            lazy: false,
            create: (_) => NetworkBloc()..add(NetworkObserve()),
          ),
          BlocProvider(
            create: (_) => NotificationBloc(
              _deviceRepository,
              _deviceListBloc,
            ),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeBuilder.getThemeData(true),
          home: BlocConsumer<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const nl.NotificationListener(
                    child: RootScreen(),
                  );
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
