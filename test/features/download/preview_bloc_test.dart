import 'package:downees/core/enums/download_status.dart';
import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/features/download/domain/entities/video_info.dart';
import 'package:downees/features/download/domain/entities/video_quality.dart';
import 'package:downees/features/download/domain/usecases/fetch_video_info.dart';
import 'package:downees/features/download/presentation/bloc/preview_bloc.dart';
import 'package:downees/features/download/presentation/bloc/preview_event.dart';
import 'package:downees/features/download/presentation/bloc/preview_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchVideoInfo extends Mock implements FetchVideoInfo {}

void main() {
  late MockFetchVideoInfo mockFetchVideoInfo;
  late PreviewBloc bloc;

  const testQuality720 = VideoQuality(
    label: '720p',
    resolution: '1280x720',
    fileSizeBytes: 36700160,
    downloadUrl: 'https://download.com/720.mp4',
    format: 'mp4',
  );

  const testQualityAudio = VideoQuality(
    label: 'MP3 128kbps',
    fileSizeBytes: 4194304,
    downloadUrl: 'https://download.com/audio.mp3',
    format: 'mp3',
    isAudioOnly: true,
  );

  final testVideoInfo = VideoInfo(
    id: 'test_id',
    title: 'Test Video',
    thumbnailUrl: 'https://thumbnail.com/pic.jpg',
    platform: PlatformType.youtube,
    qualities: const [testQuality720],
    audioQualities: const [testQualityAudio],
  );

  setUp(() {
    mockFetchVideoInfo = MockFetchVideoInfo();
    bloc = PreviewBloc(fetchVideoInfo: mockFetchVideoInfo);
  });

  tearDown(() {
    bloc.close();
  });

  group('PreviewBloc', () {
    test('initial state is default PreviewState', () {
      expect(bloc.state, const PreviewState());
    });

    test('should fetch video info successfully and set default quality', () async {
      when(() => mockFetchVideoInfo(any()))
          .thenAnswer((_) async => testVideoInfo);

      bloc.add(const FetchVideoInfoEvent('https://youtube.com/watch?v=test_id'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PreviewState>().having((s) => s.isLoading, 'isLoading', true),
          isA<PreviewState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.videoInfo, 'videoInfo', testVideoInfo)
              .having((s) => s.selectedQuality, 'selectedQuality', testQuality720),
        ]),
      );
    });

    test('should toggle format between video and audio', () {
      bloc.emit(PreviewState(videoInfo: testVideoInfo, selectedQuality: testQuality720));

      bloc.add(const SelectFormatEvent(true));

      expectLater(
        bloc.stream,
        emits(
          isA<PreviewState>()
              .having((s) => s.isAudioOnly, 'isAudioOnly', true)
              .having((s) => s.selectedQuality, 'selectedQuality', testQualityAudio),
        ),
      );
    });

    test('should select quality', () {
      bloc.emit(PreviewState(videoInfo: testVideoInfo));

      bloc.add(const SelectQualityEvent(testQuality720));

      expectLater(
        bloc.stream,
        emits(
          isA<PreviewState>().having((s) => s.selectedQuality, 'selectedQuality', testQuality720),
        ),
      );
    });

    test('should update status on StartDownloadEvent', () {
      bloc.emit(PreviewState(videoInfo: testVideoInfo, selectedQuality: testQuality720));

      bloc.add(const StartDownloadEvent());

      expectLater(
        bloc.stream,
        emits(
          isA<PreviewState>().having(
            (s) => s.downloadStatus,
            'downloadStatus',
            DownloadStatus.downloading,
          ),
        ),
      );
    });

    test('should show error when fetching video info fails', () async {
      when(() => mockFetchVideoInfo(any()))
          .thenThrow(Exception('Server error occurred'));

      bloc.add(const FetchVideoInfoEvent('https://youtube.com/watch?v=error'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PreviewState>().having((s) => s.isLoading, 'isLoading', true),
          isA<PreviewState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.error, 'error', contains('Server error occurred')),
        ]),
      );
    });
  });
}

