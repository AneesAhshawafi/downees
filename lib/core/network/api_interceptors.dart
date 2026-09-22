import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = RetryOptions.fromExtra(err.requestOptions);
    final shouldRetry = _shouldRetry(err);

    if (shouldRetry && extra.retryCount < maxRetries) {
      extra.retryCount++;
      err.requestOptions.extra[RetryOptions.extraKey] = extra;

      final delay = retryDelay * extra.retryCount;
      await Future.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response != null &&
            error.response!.statusCode != null &&
            error.response!.statusCode! >= 500);
  }
}

class RetryOptions {
  static const extraKey = 'retry_options';
  int retryCount;

  RetryOptions({this.retryCount = 0});

  factory RetryOptions.fromExtra(RequestOptions request) {
    return request.extra[extraKey] as RetryOptions? ?? RetryOptions();
  }
}

