import 'package:equatable/equatable.dart';
import '../../../../core/enums/download_status.dart';
import '../../../../core/enums/platform_type.dart';

class DownloadTask extends Equatable {
  final String id;
  final String url;
  final String originalUrl;
  final String title;
  final String thumbnailUrl;
  final PlatformType platform;
  final String quality;
  final String format;
  final int totalBytes;
  final int receivedBytes;
  final DownloadStatus status;
  final String savePath;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final int retryCount;

  const DownloadTask({
    required this.id,
    required this.url,
    required this.originalUrl,
    required this.title,
    required this.thumbnailUrl,
    required this.platform,
    required this.quality,
    this.format = 'mp4',
    this.totalBytes = 0,
    this.receivedBytes = 0,
    this.status = DownloadStatus.pending,
    this.savePath = '',
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
    this.retryCount = 0,
  });

  double get progress => totalBytes > 0 ? (receivedBytes / totalBytes).clamp(0.0, 1.0) : 0.0;
  String get progressPercent => '${(progress * 100).toInt()}%';
  String get receivedMB => (receivedBytes / 1024 / 1024).toStringAsFixed(1);
  String get totalMB => (totalBytes / 1024 / 1024).toStringAsFixed(1);
  String get fileSize => '$totalMB MB';
  String get progressText => '$receivedMB / $totalMB MB';

  DownloadTask copyWith({
    String? id,
    String? url,
    String? originalUrl,
    String? title,
    String? thumbnailUrl,
    PlatformType? platform,
    String? quality,
    String? format,
    int? totalBytes,
    int? receivedBytes,
    DownloadStatus? status,
    String? savePath,
    DateTime? createdAt,
    DateTime? completedAt,
    String? errorMessage,
    int? retryCount,
  }) {
    return DownloadTask(
      id: id ?? this.id,
      url: url ?? this.url,
      originalUrl: originalUrl ?? this.originalUrl,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      platform: platform ?? this.platform,
      quality: quality ?? this.quality,
      format: format ?? this.format,
      totalBytes: totalBytes ?? this.totalBytes,
      receivedBytes: receivedBytes ?? this.receivedBytes,
      status: status ?? this.status,
      savePath: savePath ?? this.savePath,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        url,
        originalUrl,
        title,
        thumbnailUrl,
        platform,
        quality,
        format,
        totalBytes,
        receivedBytes,
        status,
        savePath,
        createdAt,
        completedAt,
        errorMessage,
        retryCount,
      ];
}

