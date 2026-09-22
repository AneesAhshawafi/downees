import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_interceptors.dart';

Dio createDio({String? baseUrl}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? ApiConstants.baseUrl,
    connectTimeout: ApiConstants.connectTimeout,
    receiveTimeout: ApiConstants.receiveTimeout,
    sendTimeout: ApiConstants.sendTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.addAll([
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
    ),
    RetryInterceptor(dio: dio, maxRetries: 3),
  ]);

  return dio;
}

