import 'dart:async';
import 'package:downees/core/enums/download_status.dart';
import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/services/download_manager.dart';
import 'package:downees/features/download/data/datasources/download_local_datasource.dart';
import 'package:downees/features/download/data/models/download_task_model.dart';
import 'package:downees/features/download/data/repositories/download_repository_impl.dart';
import 'package:downees/features/download/domain/entities/download_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadManager extends Mock implements DownloadManager {}
class MockDownloadLocalDataSource extends Mock implements DownloadLocalDataSource {}
class FakeDownloadTaskModel extends Fake implements DownloadTaskModel {}

void main() {
  late MockDownloadManager mockManager;
  late MockDownloadLocalDataSource mockDataSource;
  late StreamController<DownloadTask> streamController;
  late DownloadRepositoryImpl repository;

  final testTask = DownloadTask(
    id: 'repo_task_1',
    url: 'https://example.com/video.mp4',
    originalUrl: 'https://youtube.com/watch?v=1',
    title: 'Test Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    platform: PlatformType.youtube,
    quality: '720p',
    status: DownloadStatus.pending,
    createdAt: DateTime(2026, 9, 23),
  );

  setUpAll(() {
    registerFallbackValue(FakeDownloadTaskModel());
  });

  setUp(() {
    mockManager = MockDownloadManager();
    mockDataSource = MockDownloadLocalDataSource();
    streamController = StreamController<DownloadTask>.broadcast();

    when(() => mockManager.progressStream).thenAnswer((_) => streamController.stream);
    when(() => mockDataSource.saveTask(any())).thenAnswer((_) async {});

    repository = DownloadRepositoryImpl(
      downloadManager: mockManager,
      localDataSource: mockDataSource,
    );
  });

  tearDown(() {
    repository.dispose();
    streamController.close();
  });

  group('DownloadRepositoryImpl', () {
    test('startDownload should persist task and invoke manager', () async {
      when(() => mockManager.startDownload(any())).thenAnswer((_) async {});

      await repository.startDownload(testTask);

      verify(() => mockDataSource.saveTask(any(that: isA<DownloadTaskModel>()))).called(1);
      verify(() => mockManager.startDownload(testTask)).called(1);
    });

    test('pauseDownload should call manager and update status', () async {
      when(() => mockManager.pauseDownload('repo_task_1')).thenReturn(null);
      when(() => mockDataSource.getTask('repo_task_1')).thenAnswer(
        (_) async => DownloadTaskModel.fromEntity(testTask),
      );

      await repository.pauseDownload('repo_task_1');

      verify(() => mockManager.pauseDownload('repo_task_1')).called(1);
      verify(() => mockDataSource.saveTask(any(
            that: isA<DownloadTaskModel>().having(
              (t) => t.status,
              'status',
              DownloadStatus.paused,
            ),
          ))).called(1);
    });

    test('getAllTasks should normalize any downloading task to paused on restart', () async {
      final activeModel = DownloadTaskModel.fromEntity(
        testTask.copyWith(id: 'active_1', status: DownloadStatus.downloading),
      );
      final completedModel = DownloadTaskModel.fromEntity(
        testTask.copyWith(id: 'done_1', status: DownloadStatus.completed),
      );

      when(() => mockDataSource.getAllTasks()).thenAnswer(
        (_) async => [activeModel, completedModel],
      );

      final result = await repository.getAllTasks();

      expect(result.first.status, DownloadStatus.paused);
      expect(result.last.status, DownloadStatus.completed);
      verify(() => mockDataSource.saveTask(any(
            that: isA<DownloadTaskModel>().having(
              (t) => t.status,
              'status',
              DownloadStatus.paused,
            ),
          ))).called(1);
    });

    test('deleteTask should cancel manager and remove from local datasource', () async {
      when(() => mockManager.cancelDownload('repo_task_1')).thenReturn(null);
      when(() => mockDataSource.deleteTask('repo_task_1')).thenAnswer((_) async {});

      await repository.deleteTask('repo_task_1');

      verify(() => mockManager.cancelDownload('repo_task_1')).called(1);
      verify(() => mockDataSource.deleteTask('repo_task_1')).called(1);
    });
  });
}

