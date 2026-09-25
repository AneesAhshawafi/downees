import 'package:dio/dio.dart';
import 'package:downees/core/enums/download_status.dart';
import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/services/download_manager.dart';
import 'package:downees/core/services/download_queue.dart';
import 'package:downees/core/services/media_muxer_service.dart';
import 'package:downees/features/download/domain/entities/download_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockMediaMuxerService extends Mock implements MediaMuxerService {}

class FakeCancelToken extends Fake implements CancelToken {}

class FakeOptions extends Fake implements Options {}

void main() {
  late MockDio mockDio;
  late DownloadQueue queue;
  late DownloadManager manager;

  final testTask = DownloadTask(
    id: 'test_task_1',
    url: 'https://example.com/video.mp4',
    originalUrl: 'https://youtube.com/watch?v=1',
    title: 'Test Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    platform: PlatformType.youtube,
    quality: '720p',
    savePath: 'test_output.mp4',
    totalBytes: 1000,
    createdAt: DateTime(2026, 9, 23),
  );

  setUpAll(() {
    registerFallbackValue(FakeCancelToken());
    registerFallbackValue(FakeOptions());
  });

  setUp(() {
    mockDio = MockDio();
    queue = DownloadQueue(2);
    manager = DownloadManager(
      dio: mockDio,
      queue: queue,
      maxConcurrent: 2,
      maxRetries: 3,
    );
  });

  tearDown(() {
    manager.dispose();
  });

  group('DownloadManager', () {
    test('should start download and emit progress', () async {
      when(
        () => mockDio.download(
          any(),
          any(),
          cancelToken: any(named: 'cancelToken'),
          deleteOnError: any(named: 'deleteOnError'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((invocation) async {
        final onProgress =
            invocation.namedArguments[#onReceiveProgress] as ProgressCallback?;
        onProgress?.call(500, 1000);
        return Response(
          requestOptions: RequestOptions(path: testTask.url),
          statusCode: 200,
        );
      });

      final states = <DownloadTask>[];
      final subscription = manager.progressStream.listen(states.add);

      await manager.startDownload(testTask);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, greaterThanOrEqualTo(3));
      expect(states[0].status, DownloadStatus.downloading);
      expect(states[1].receivedBytes, 500);
      expect(states.last.status, DownloadStatus.completed);

      await subscription.cancel();
    });

    test(
      'should queue downloads when max concurrency limit is reached',
      () async {
        // Mock dio download to hang until released
        when(
          () => mockDio.download(
            any(),
            any(),
            cancelToken: any(named: 'cancelToken'),
            deleteOnError: any(named: 'deleteOnError'),
            options: any(named: 'options'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(seconds: 1),
            () => Response(
              requestOptions: RequestOptions(path: 'path'),
              statusCode: 200,
            ),
          ),
        );

        final task1 = testTask.copyWith(id: 'task_1');
        final task2 = testTask.copyWith(id: 'task_2');
        final task3 = testTask.copyWith(id: 'task_3');

        final states = <DownloadTask>[];
        final subscription = manager.progressStream.listen(states.add);

        // Start 3 downloads with maxConcurrent = 2
        manager.startDownload(task1);
        manager.startDownload(task2);
        await manager.startDownload(task3);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(queue.activeCount, 2);
        expect(queue.pendingCount, 1);
        expect(
          states.any(
            (t) => t.id == 'task_3' && t.status == DownloadStatus.pending,
          ),
          isTrue,
        );

        await subscription.cancel();
      },
    );

    test('should pause and resume download with range header', () async {
      Map<String, dynamic>? capturedHeaders;

      when(
        () => mockDio.download(
          any(),
          any(),
          cancelToken: any(named: 'cancelToken'),
          deleteOnError: any(named: 'deleteOnError'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((invocation) async {
        final options = invocation.namedArguments[#options] as Options?;
        capturedHeaders = options?.headers;
        return Response(
          requestOptions: RequestOptions(path: testTask.url),
          statusCode: 200,
        );
      });

      // Pause before download or with current bytes
      manager.pauseDownload(testTask.id, currentBytes: 450);
      expect(manager.getPausedBytes(testTask.id), 450);

      // Resume download
      await manager.resumeDownload(testTask.copyWith(receivedBytes: 450));

      expect(capturedHeaders, isNotNull);
      expect(capturedHeaders?['Range'], 'bytes=450-');
    });

    test('should auto-retry on network failure up to maxRetries', () async {
      int attempts = 0;
      final fastRetryManager = DownloadManager(
        dio: mockDio,
        queue: queue,
        maxRetries: 2,
      );

      when(
        () => mockDio.download(
          any(),
          any(),
          cancelToken: any(named: 'cancelToken'),
          deleteOnError: any(named: 'deleteOnError'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async {
        attempts++;
        throw DioException(
          requestOptions: RequestOptions(path: testTask.url),
          type: DioExceptionType.connectionTimeout,
        );
      });

      final states = <DownloadTask>[];
      final sub = fastRetryManager.progressStream.listen(states.add);

      await fastRetryManager.startDownload(testTask.copyWith(retryCount: 2));
      await Future.delayed(const Duration(milliseconds: 50));

      expect(attempts, 1);
      expect(states.last.status, DownloadStatus.failed);
      expect(states.last.errorMessage, 'انتهت مهلة الاتصال');

      await sub.cancel();
      fastRetryManager.dispose();
    });

    test(
      'should download video and audio and mux when audioUrl is present',
      () async {
        final mockMuxer = MockMediaMuxerService();
        when(
          () => mockMuxer.muxVideoAndAudio(
            videoPath: any(named: 'videoPath'),
            audioPath: any(named: 'audioPath'),
            outputPath: any(named: 'outputPath'),
          ),
        ).thenAnswer((_) async => true);
        when(() => mockMuxer.scanFile(any())).thenAnswer((_) async {});

        final muxManager = DownloadManager(
          dio: mockDio,
          queue: queue,
          mediaMuxerService: mockMuxer,
        );

        when(
          () => mockDio.download(
            any(),
            any(),
            cancelToken: any(named: 'cancelToken'),
            deleteOnError: any(named: 'deleteOnError'),
            options: any(named: 'options'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          ),
        ).thenAnswer((invocation) async {
          return Response(
            requestOptions: RequestOptions(path: testTask.url),
            statusCode: 200,
          );
        });

        final muxTask = testTask.copyWith(
          id: 'mux_task_1',
          audioUrl: 'https://example.com/audio.m4a',
        );

        final states = <DownloadTask>[];
        final sub = muxManager.progressStream.listen(states.add);

        await muxManager.startDownload(muxTask);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states.last.status, DownloadStatus.completed);
        verify(
          () => mockMuxer.muxVideoAndAudio(
            videoPath: any(named: 'videoPath'),
            audioPath: any(named: 'audioPath'),
            outputPath: any(named: 'outputPath'),
          ),
        ).called(1);
        verify(() => mockMuxer.scanFile(any())).called(1);

        await sub.cancel();
        muxManager.dispose();
      },
    );
  });
}
