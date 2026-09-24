import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'api_interceptors.dart';

Dio createDio({String? baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true, requestHeader: true),
    RetryInterceptor(dio: dio, maxRetries: 3),
  ]);

  return dio;
}

Dio createDownloadDio() {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: Duration.zero,
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        'Accept': '*/*',
      },
      followRedirects: true,
    ),
  );
}
