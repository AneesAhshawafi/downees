import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/video_info_model.dart';

abstract class VideoRemoteDataSource {
  Future<VideoInfoModel> fetchVideoInfo(String url);
}

class VideoApiDatasource implements VideoRemoteDataSource {
  final Dio _dio;

  VideoApiDatasource(this._dio);

  @override
  Future<VideoInfoModel> fetchVideoInfo(String url) async {
    try {
      final response = await _dio.post(
        ApiConstants.videoInfo,
        data: {'url': url},
      );

      if (response.data is Map<String, dynamic>) {
        return VideoInfoModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw const ServerException('Invalid response format received from server');
      }
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(e.toString());
    }
  }

  Exception _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException('Network connection failed or timed out');
    }

    final statusCode = e.response?.statusCode;
    final message = (e.response?.data is Map && e.response?.data['message'] != null)
        ? e.response!.data['message'].toString()
        : e.message ?? 'Server error occurred';

    if (statusCode == 400 || statusCode == 422) {
      return InvalidUrlException(message);
    }

    return ServerException(message, statusCode);
  }
}

