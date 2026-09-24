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
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: Duration.zero,
      sendTimeout: const Duration(seconds: 30),
      followRedirects: true,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final host = options.uri.host.toLowerCase();
        if (host.contains('googlevideo.com') || host.contains('youtube.com')) {
          options.headers['User-Agent'] =
              'com.google.android.youtube/20.10.38 (Linux; U; Android 11) gzip';
        } else {
          options.headers['User-Agent'] = 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';
        }
        options.headers['Accept'] = '*/*';
        return handler.next(options);
      },
    ),
  );

  return dio;
}
