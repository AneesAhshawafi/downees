import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/utils/clipboard_watcher.dart';
import 'package:downees/features/home/presentation/bloc/home_bloc.dart';
import 'package:downees/features/home/presentation/bloc/home_event.dart';
import 'package:downees/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClipboardWatcher extends Mock implements ClipboardWatcher {}

void main() {
  late MockClipboardWatcher mockClipboardWatcher;
  late HomeBloc bloc;

  setUp(() {
    mockClipboardWatcher = MockClipboardWatcher();
    bloc = HomeBloc(clipboardWatcher: mockClipboardWatcher);
  });

  tearDown(() {
    bloc.close();
  });

  group('HomeBloc', () {
    test('initial state has empty defaults', () {
      expect(bloc.state, const HomeState());
    });

    test('UrlChanged detects YouTube platform and validity', () {
      const testUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
      bloc.add(const UrlChanged(testUrl));

      expectLater(
        bloc.stream,
        emits(
          predicate<HomeState>((state) =>
              state.currentUrl == testUrl &&
              state.detectedPlatform == PlatformType.youtube &&
              state.isValidUrl == true),
        ),
      );
    });

    test('UrlChanged handles invalid url', () {
      const invalidUrl = 'not a valid url';
      bloc.add(const UrlChanged(invalidUrl));

      expectLater(
        bloc.stream,
        emits(
          predicate<HomeState>((state) =>
              state.currentUrl == invalidUrl &&
              state.detectedPlatform == null &&
              state.isValidUrl == false),
        ),
      );
    });

    test('SmartPasteDetected shows smart paste banner', () {
      const tiktokUrl = 'https://www.tiktok.com/@user/video/1234567890';
      bloc.add(const SmartPasteDetected(tiktokUrl, PlatformType.tiktok));

      expectLater(
        bloc.stream,
        emits(
          predicate<HomeState>((state) =>
              state.showSmartPaste == true &&
              state.smartPasteUrl == tiktokUrl &&
              state.smartPastePlatform == PlatformType.tiktok),
        ),
      );
    });

    test('SmartPasteDismissed hides banner', () {
      bloc.emit(const HomeState(
        showSmartPaste: true,
        smartPasteUrl: 'https://youtu.be/xxx',
        smartPastePlatform: PlatformType.youtube,
      ));

      bloc.add(SmartPasteDismissed());

      expectLater(
        bloc.stream,
        emits(
          predicate<HomeState>((state) =>
              state.showSmartPaste == false &&
              state.smartPasteUrl == null &&
              state.smartPastePlatform == null),
        ),
      );
    });

    test('SubmitUrl emits navigateToPreviewUrl when URL is valid', () {
      const validUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
      bloc.emit(const HomeState(
        currentUrl: validUrl,
        isValidUrl: true,
      ));

      bloc.add(SubmitUrl());

      expectLater(
        bloc.stream,
        emits(
          predicate<HomeState>((state) => state.navigateToPreviewUrl == validUrl),
        ),
      );
    });

    test('AppResumed triggers clipboard check and shows banner if found', () async {
      const igUrl = 'https://www.instagram.com/reel/C123xyz/';
      when(() => mockClipboardWatcher.checkClipboard()).thenAnswer(
        (_) async => (url: igUrl, platform: PlatformType.instagram),
      );

      bloc.add(AppResumed());

      await expectLater(
        bloc.stream,
        emits(
          predicate<HomeState>((state) =>
              state.showSmartPaste == true &&
              state.smartPasteUrl == igUrl &&
              state.smartPastePlatform == PlatformType.instagram),
        ),
      );
    });
  });
}

