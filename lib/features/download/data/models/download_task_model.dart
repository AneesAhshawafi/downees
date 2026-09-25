import '../../../../core/enums/download_status.dart';
import '../../../../core/enums/platform_type.dart';
import '../../domain/entities/download_task.dart';

class DownloadTaskModel extends DownloadTask {
  const DownloadTaskModel({
    required super.id,
    required super.url,
    required super.originalUrl,
    required super.title,
    required super.thumbnailUrl,
    required super.platform,
    required super.quality,
    super.format = 'mp4',
    super.totalBytes = 0,
    super.receivedBytes = 0,
    super.status = DownloadStatus.pending,
    super.savePath = '',
    required super.createdAt,
    super.completedAt,
    super.errorMessage,
    super.retryCount = 0,
    super.audioUrl,
  });

  factory DownloadTaskModel.fromEntity(DownloadTask task) {
    return DownloadTaskModel(
      id: task.id,
      url: task.url,
      originalUrl: task.originalUrl,
      title: task.title,
      thumbnailUrl: task.thumbnailUrl,
      platform: task.platform,
      quality: task.quality,
      format: task.format,
      totalBytes: task.totalBytes,
      receivedBytes: task.receivedBytes,
      status: task.status,
      savePath: task.savePath,
      createdAt: task.createdAt,
      completedAt: task.completedAt,
      errorMessage: task.errorMessage,
      retryCount: task.retryCount,
      audioUrl: task.audioUrl,
    );
  }

  factory DownloadTaskModel.fromMap(Map<dynamic, dynamic> map) {
    PlatformType parsePlatform(dynamic value) {
      if (value is String) {
        try {
          return PlatformType.values.byName(value);
        } catch (_) {
          return PlatformType.unknown;
        }
      }
      return PlatformType.unknown;
    }

    DownloadStatus parseStatus(dynamic value) {
      if (value is String) {
        try {
          return DownloadStatus.values.byName(value);
        } catch (_) {
          return DownloadStatus.pending;
        }
      }
      return DownloadStatus.pending;
    }

    DateTime parseDate(dynamic value) {
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    DateTime? parseNullableDate(dynamic value) {
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    int parseInt(dynamic value) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return DownloadTaskModel(
      id: (map['id'] as String?) ?? '',
      url: (map['url'] as String?) ?? '',
      originalUrl: (map['originalUrl'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      thumbnailUrl: (map['thumbnailUrl'] as String?) ?? '',
      platform: parsePlatform(map['platform']),
      quality: (map['quality'] as String?) ?? '',
      format: (map['format'] as String?) ?? 'mp4',
      totalBytes: parseInt(map['totalBytes']),
      receivedBytes: parseInt(map['receivedBytes']),
      status: parseStatus(map['status']),
      savePath: (map['savePath'] as String?) ?? '',
      createdAt: parseDate(map['createdAt']),
      completedAt: parseNullableDate(map['completedAt']),
      errorMessage: map['errorMessage'] as String?,
      retryCount: parseInt(map['retryCount']),
      audioUrl: map['audioUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'originalUrl': originalUrl,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'platform': platform.name,
      'quality': quality,
      'format': format,
      'totalBytes': totalBytes,
      'receivedBytes': receivedBytes,
      'status': status.name,
      'savePath': savePath,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'retryCount': retryCount,
      'audioUrl': audioUrl,
    };
  }

  DownloadTask toEntity() {
    return DownloadTask(
      id: id,
      url: url,
      originalUrl: originalUrl,
      title: title,
      thumbnailUrl: thumbnailUrl,
      platform: platform,
      quality: quality,
      format: format,
      totalBytes: totalBytes,
      receivedBytes: receivedBytes,
      status: status,
      savePath: savePath,
      createdAt: createdAt,
      completedAt: completedAt,
      errorMessage: errorMessage,
      retryCount: retryCount,
      audioUrl: audioUrl,
    );
  }
}
