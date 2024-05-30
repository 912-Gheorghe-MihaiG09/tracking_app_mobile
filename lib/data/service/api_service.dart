import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tracking_app/data/service/interceptors/auth_interceptor.dart';
import 'package:tracking_app/data/service/exceptions/network_exception.dart'
    as network;

abstract class ApiService {
  final String discountCodeUrl = "/api/discount";
  final String baseUrl;
  final Dio dio;
  final AuthInterceptor? _authInterceptor;

  ApiService(this.dio, this._authInterceptor, {required this.baseUrl}) {
    initDioOptions();
  }

  initDioOptions() async {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
    dio.interceptors.clear();
    if (_authInterceptor != null) {
      dio.interceptors.add(_authInterceptor!);
    }
    dio.interceptors.addAll([
      InterceptorsWrapper(onError: errorHandler),
    ]);
  }

  void errorHandler(DioError e, ErrorInterceptorHandler handler) async {
    if (e.requestOptions.cancelToken?.isCancelled ?? false) {
      return;
    }
    if (e.type == DioErrorType.connectionTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      handler.next(network.TimeoutException(
          requestOptions: e.requestOptions, message: e.message ?? ""));
      return;
    }
    if (e.error is SocketException) {
      handler.next(network.NoInternetConnectionException(
          requestOptions: e.requestOptions));
      return;
    }
    if (e.response == null) {
      handler.next(network.UnknownException(
          requestOptions: e.requestOptions, message: e.message ?? ""));
      return;
    }
    var statusCode = e.response!.statusCode;
    switch (statusCode) {
      case 400:
        handler.next(network.BadRequestException(
            requestOptions: e.requestOptions,
            statusCode: statusCode,
            message: e.message ?? ""));
        break;
      case 403:
        handler.next(network.ForbiddenException(
            requestOptions: e.requestOptions,
            statusCode: statusCode,
            message: e.message ?? ""));
        break;
      case 404:
        handler.next(network.NotFoundException(
            requestOptions: e.requestOptions,
            statusCode: statusCode,
            message: e.message ?? ""));
        break;
      case 500:
        handler.next(network.InternalServerErrorException(
            requestOptions: e.requestOptions,
            statusCode: statusCode,
            message: e.message ?? ""));
        break;
      default:
        handler.next(network.UnknownException(
            requestOptions: e.requestOptions, message: e.message ?? ""));
        break;
    }
  }
}
