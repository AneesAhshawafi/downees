import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:downees/core/enums/download_status.dart';
import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/features/download/domain/entities/download_task.dart';
import 'package:downees/features/download/domain/repositories/download_repository.dart';
import 'package:downees/features/download/domain/usecases/cancel_download.dart';
import 'package:downees/features/download/domain/usecases/pause_download.dart';
import 'package:downees/features/download/domain/usecases/resume_download.dart';
import 'package:downees/features/download/domain/usecases/retry_download.dart';
import 'package:downees/features/download/domain/usecases/start_download.dart';
import 'package:downees/features/download/presentation/bloc/download_bloc.dart';
import 'package:downees/features/download/presentation/bloc/download_event.dart';
import 'package:downees/features/download/presentation/bloc/download_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadRepository extends Mock implements DownloadRepository {}

class MockStartDownloadUseCase extends Mock implements StartDownloadUseCase {}

class MockPauseDownloadUseCase extends Mock implements PauseDownloadUseCase {}

class MockResumeDownloadUseCase extends Mock implements ResumeDownloadUseCase {}

class MockCancelDownloadUseCase extends Mock implements CancelDownloadUseCase {}

class MockRetryDownloadUseCase extends Mock implements RetryDownloadUseCase {}

class FakeDownloadTask extends Fake implements DownloadTask {}

void main() {
  late MockDownloadRepository mockRepository;
  late MockStartDownloadUseCase mockStartDownload;
  late MockPauseDownloadUseCase mockPauseDownload;
  late MockResumeDownloadUseCase mockResumeDownload;
  late MockCancelDownloadUseCase mockCancelDownload;
  late MockRetryDownloadUseCase mockRetryDownload;
  late StreamController<DownloadTask> streamController;
  late DownloadBloc bloc;

  final testTask = DownloadTask(
    id: 'bloc_task_1',
    url: 'https://example.com/video.mp4',
    originalUrl: 'https://youtube.com/watch?v=1',
    title: 'Test Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    platform: PlatformType.youtube,
    quality: '720p',
    status: DownloadStatus.downloading,
    createdAt: DateTime(2026, 9, 23),
  );

  setUpAll(() {
    registerFallbackValue(FakeDownloadTask());
  });

  setUp(() {
    mockRepository = MockDownloadRepository();
    mockStartDownload = MockStartDownloadUseCase();
    mockPauseDownload = MockPauseDownloadUseCase();
    mockResumeDownload = MockResumeDownloadUseCase();
    mockCancelDownload = MockCancelDownloadUseCase();
    mockRetryDownload = MockRetryDownloadUseCase();
    streamController = StreamController<DownloadTask>.broadcast();

    when(() => mockRepository.progressStream)
        .thenAnswer((_) => streamController.stream);

    bloc = DownloadBloc(
      downloadRepository: mockRepository,
      startDownloadUseCase: mockStartDownload,
      pauseDownloadUseCase: mockPauseDownload,
      resumeDownloadUseCase: mockResumeDownload,
      cancelDownloadUseCase: mockCancelDownload,
      retryDownloadUseCase: mockRetryDownload,
    );
  });

  tearDown(() {
    bloc.close();
    streamController.close();
  });

  group('DownloadBloc', () {
    test('initial state has empty tasks map', () {
      expect(bloc.state.tasks, isEmpty);
      expect(bloc.state.activeTasks, isEmpty);
    });

    blocTest<DownloadBloc, DownloadState>(
      'LoadDownloads populates tasks from repository',
      build: () {
        when(() => mockRepository.getAllTasks())
            .thenAnswer((_) async => [testTask]);
        return bloc;
      },
      act: (b) => b.add(const LoadDownloads()),
      expect: () => [
        isA<DownloadState>().having(
          (s) => s.tasks.containsKey('bloc_task_1'),
          'has task',
          isTrue,
        ),
      ],
    );

    blocTest<DownloadBloc, DownloadState>(
      'PauseDownload triggers pauseUseCase and updates state status',
      build: () {
        when(() => mockPauseDownload.call(any())).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => DownloadState(tasks: {'bloc_task_1': testTask}),
      act: (b) => b.add(const PauseDownload('bloc_task_1')),
      expect: () => [
        isA<DownloadState>().having(
          (s) => s.tasks['bloc_task_1']?.status,
          'status',
          DownloadStatus.paused,
        ),
      ],
      verify: (_) {
        verify(() => mockPauseDownload.call('bloc_task_1')).called(1);
      },
    );

    blocTest<DownloadBloc, DownloadState>(
      'CancelDownload triggers cancelUseCase and sets cancelled status',
      build: () {
        when(
          () =>
              mockCancelDownload.call(any(), savePath: any(named: 'savePath')),
        ).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => DownloadState(tasks: {'bloc_task_1': testTask}),
      act: (b) => b.add(const CancelDownload('bloc_task_1')),
      expect: () => [
        isA<DownloadState>().having(
          (s) => s.tasks['bloc_task_1']?.status,
          'status',
          DownloadStatus.cancelled,
        ),
      ],
      verify: (_) {
        verify(
          () => mockCancelDownload.call(
            'bloc_task_1',
            savePath: any(named: 'savePath'),
          ),
        ).called(1);
      },
    );

    blocTest<DownloadBloc, DownloadState>(
      'DownloadProgressUpdated updates progress in state',
      build: () => bloc,
      act: (b) => b.add(
        DownloadProgressUpdated(
          testTask.copyWith(receivedBytes: 500, totalBytes: 1000),
        ),
      ),
      expect: () => [
        isA<DownloadState>().having(
          (s) => s.tasks['bloc_task_1']?.progressPercent,
          'progress',
          '50%',
        ),
      ],
    );
  });
}
