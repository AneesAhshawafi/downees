import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/features/download/data/datasources/download_local_datasource.dart';
import 'package:downees/features/download/data/models/download_task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box {}

void main() {
  late MockBox mockBox;
  late DownloadLocalDataSourceImpl dataSource;

  final testTask = DownloadTaskModel(
    id: 'test_1',
    url: 'https://example.com/video.mp4',
    originalUrl: 'https://youtube.com/watch?v=1',
    title: 'Test Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    platform: PlatformType.youtube,
    quality: '720p',
    createdAt: DateTime(2026, 9, 23),
  );

  setUp(() {
    mockBox = MockBox();
    dataSource = DownloadLocalDataSourceImpl(mockBox);
  });

  group('DownloadLocalDataSourceImpl', () {
    test('saveTask should put serialized map into Hive box', () async {
      when(() => mockBox.put('test_1', any())).thenAnswer((_) async {});

      await dataSource.saveTask(testTask);

      verify(() => mockBox.put('test_1', testTask.toMap())).called(1);
    });

    test('getTask should return DownloadTaskModel if found', () async {
      when(() => mockBox.get('test_1')).thenReturn(testTask.toMap());

      final result = await dataSource.getTask('test_1');

      expect(result, isNotNull);
      expect(result?.id, 'test_1');
      expect(result?.title, 'Test Video');
    });

    test('getTask should return null if not found', () async {
      when(() => mockBox.get('unknown')).thenReturn(null);

      final result = await dataSource.getTask('unknown');

      expect(result, isNull);
    });

    test('getAllTasks should return sorted list of tasks (newest first)', () async {
      final olderTask = testTask.copyWith(
        id: 'older',
        createdAt: DateTime(2026, 9, 20),
      );
      final newerTask = testTask.copyWith(
        id: 'newer',
        createdAt: DateTime(2026, 9, 23),
      );

      when(() => mockBox.keys).thenReturn(['older', 'newer']);
      when(() => mockBox.get('older')).thenReturn(DownloadTaskModel.fromEntity(olderTask).toMap());
      when(() => mockBox.get('newer')).thenReturn(DownloadTaskModel.fromEntity(newerTask).toMap());

      final results = await dataSource.getAllTasks();

      expect(results.length, 2);
      expect(results.first.id, 'newer');
      expect(results.last.id, 'older');
    });

    test('deleteTask should delete key from Hive box', () async {
      when(() => mockBox.delete('test_1')).thenAnswer((_) async {});

      await dataSource.deleteTask('test_1');

      verify(() => mockBox.delete('test_1')).called(1);
    });

    test('clearAllTasks should clear Hive box', () async {
      when(() => mockBox.clear()).thenAnswer((_) async => 0);

      await dataSource.clearAllTasks();

      verify(() => mockBox.clear()).called(1);
    });
  });
}

