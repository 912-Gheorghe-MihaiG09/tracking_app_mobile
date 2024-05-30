import 'package:dio/dio.dart';

class NetworkException extends DioError {
  int? statusCode;
  String message;

  NetworkException(
      {required super.requestOptions, this.statusCode, this.message = ""});

  @override
  String toString() {
    return 'NetworkException{statusCode: $statusCode, message: $message}';
  }
}

class DataParsingException implements Exception {
  @override
  String toString() {
    return 'An error occurred while parsing the data';
  }
}

class BadRequestException extends NetworkException {
  BadRequestException(
      {required super.requestOptions, super.statusCode, super.message});

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends NetworkException {
  InternalServerErrorException(
      {required super.requestOptions, super.statusCode, super.message})
      : super();

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ForbiddenException extends NetworkException {
  ForbiddenException(
      {required super.requestOptions, super.statusCode, super.message})
      : super();

  @override
  String toString() {
    return 'The request is forbidden.';
  }
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(
      {required super.requestOptions, super.statusCode, super.message})
      : super();

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends NetworkException {
  NotFoundException(
      {required super.requestOptions, super.statusCode, super.message})
      : super();

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends NetworkException {
  NoInternetConnectionException(
      {required super.requestOptions, super.statusCode, super.message})
      : super();

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class TimeoutException extends NetworkException {
  TimeoutException(
      {required super.requestOptions, super.statusCode, super.message})
      : super();

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}

class UnknownException extends NetworkException {
  UnknownException(
      {required super.requestOptions, super.statusCode, super.message})
      : super();

  @override
  String toString() {
    return 'An error has occurred, please try again.';
  }
}
