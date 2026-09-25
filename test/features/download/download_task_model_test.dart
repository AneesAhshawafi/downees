import 'package:downees/core/enums/download_status.dart';
import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/features/download/data/models/download_task_model.dart';
import 'package:downees/features/download/domain/entities/download_task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DownloadTaskModel', () {
    final now = DateTime(2026, 9, 23, 2, 0, 0);
    final completed = DateTime(2026, 9, 23, 2, 5, 0);

    final testEntity = DownloadTask(
      id: 'task_1',
      url: 'https://example.com/video.mp4',
      originalUrl: 'https://youtube.com/watch?v=123',
      title: 'Amazing Nature 4K',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      platform: PlatformType.youtube,
      quality: '1080p',
      format: 'mp4',
      totalBytes: 10485760,
      receivedBytes: 5242880,
      status: DownloadStatus.downloading,
      savePath: '/downloads/Amazing_Nature.mp4',
      createdAt: now,
      completedAt: completed,
      errorMessage: null,
      retryCount: 1,
    );

    test('should convert to map and back correctly', () {
      final model = DownloadTaskModel.fromEntity(testEntity);
      final map = model.toMap();

      expect(map['id'], 'task_1');
      expect(map['platform'], 'youtube');
      expect(map['status'], 'downloading');
      expect(map['totalBytes'], 10485760);

      final restored = DownloadTaskModel.fromMap(map);
      expect(restored.id, model.id);
      expect(restored.url, model.url);
      expect(restored.title, model.title);
      expect(restored.platform, PlatformType.youtube);
      expect(restored.status, DownloadStatus.downloading);
      expect(restored.totalBytes, 10485760);
      expect(restored.receivedBytes, 5242880);
      expect(restored.progressPercent, '50%');
    });

    test('should handle invalid or unknown values gracefully', () {
      final invalidMap = <String, dynamic>{
        'id': 'fallback_id',
        'platform': 'unknown_platform_value',
        'status': 'unknown_status_value',
        'totalBytes': 'invalid',
        'createdAt': 'invalid_date',
      };

      final model = DownloadTaskModel.fromMap(invalidMap);
      expect(model.id, 'fallback_id');
      expect(model.platform, PlatformType.unknown);
      expect(model.status, DownloadStatus.pending);
      expect(model.totalBytes, 0);
      expect(model.createdAt, isNotNull);
    });

    test('should correctly convert to entity', () {
      final model = DownloadTaskModel.fromEntity(testEntity);
      final entity = model.toEntity();

      expect(entity, equals(testEntity));
    });
  });
}

