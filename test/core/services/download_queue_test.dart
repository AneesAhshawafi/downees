import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/services/download_queue.dart';
import 'package:downees/features/download/domain/entities/download_task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DownloadTask createTask(String id) {
    return DownloadTask(
      id: id,
      url: 'https://example.com/video_$id.mp4',
      originalUrl: 'https://youtube.com/watch?v=$id',
      title: 'Test Video $id',
      thumbnailUrl: 'https://example.com/thumb_$id.jpg',
      platform: PlatformType.youtube,
      quality: '720p',
      createdAt: DateTime.now(),
    );
  }

  group('DownloadQueue', () {
    late DownloadQueue queue;

    setUp(() {
      queue = DownloadQueue(3);
    });

    test('should respect max concurrent limit', () {
      expect(queue.canStartNext, isTrue);

      queue.markActive('1');
      expect(queue.canStartNext, isTrue);

      queue.markActive('2');
      expect(queue.canStartNext, isTrue);

      queue.markActive('3');
      expect(queue.canStartNext, isFalse);
      expect(queue.activeCount, 3);
    });

    test('should process queued items in FIFO order when slots become available', () {
      final task4 = createTask('4');

      queue.markActive('1');
      queue.markActive('2');
      queue.markActive('3');

      queue.enqueue(task4);
      expect(queue.pendingCount, 1);
      expect(queue.processNext(), isNull); // Max concurrent reached

      queue.markCompleted('1');
      expect(queue.canStartNext, isTrue);

      final next = queue.processNext();
      expect(next?.id, '4');
      expect(queue.pendingCount, 0);
    });

    test('should remove task from queue', () {
      final task = createTask('task_to_cancel');
      queue.enqueue(task);
      expect(queue.isQueued('task_to_cancel'), isTrue);

      queue.removeFromQueue('task_to_cancel');
      expect(queue.isQueued('task_to_cancel'), isFalse);
    });
  });
}
