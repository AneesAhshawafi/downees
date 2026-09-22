import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/platform_type.dart';
import '../../../../core/utils/clipboard_watcher.dart';
import '../../../../core/utils/url_parser.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ClipboardWatcher clipboardWatcher;

  HomeBloc({required this.clipboardWatcher}) : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<UrlChanged>(_onUrlChanged);
    on<PasteFromClipboard>(_onPasteFromClipboard);
    on<SubmitUrl>(_onSubmitUrl);
    on<SmartPasteDetected>(_onSmartPasteDetected);
    on<SmartPasteDismissed>(_onSmartPasteDismissed);
    on<AppResumed>(_onAppResumed);
  }

  Future<void> _onHomeStarted(HomeStarted event, Emitter<HomeState> emit) async {
    await _checkClipboardInternal(emit);
  }

  Future<void> _onAppResumed(AppResumed event, Emitter<HomeState> emit) async {
    await _checkClipboardInternal(emit);
  }

  void _onUrlChanged(UrlChanged event, Emitter<HomeState> emit) {
    final text = event.url.trim();
    if (text.isEmpty) {
      emit(state.copyWith(
        currentUrl: '',
        isValidUrl: false,
        clearDetectedPlatform: true,
        clearNavigateToPreview: true,
      ));
      return;
    }

    final parsed = UrlParser.parse(text);
    emit(state.copyWith(
      currentUrl: event.url,
      detectedPlatform: parsed.platform != PlatformType.unknown ? parsed.platform : null,
      clearDetectedPlatform: parsed.platform == PlatformType.unknown,
      isValidUrl: parsed.isValid,
      clearNavigateToPreview: true,
    ));
  }

  Future<void> _onPasteFromClipboard(
      PasteFromClipboard event, Emitter<HomeState> emit) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isNotEmpty) {
      final parsed = UrlParser.parse(text);
      emit(state.copyWith(
        currentUrl: text,
        detectedPlatform: parsed.platform != PlatformType.unknown ? parsed.platform : null,
        clearDetectedPlatform: parsed.platform == PlatformType.unknown,
        isValidUrl: parsed.isValid,
        clearNavigateToPreview: true,
      ));
    }
  }

  void _onSubmitUrl(SubmitUrl event, Emitter<HomeState> emit) {
    final urlToSubmit = state.showSmartPaste && (state.smartPasteUrl?.isNotEmpty ?? false)
        ? state.smartPasteUrl!
        : state.currentUrl.trim();

    if (urlToSubmit.isNotEmpty && UrlParser.isValidUrl(urlToSubmit)) {
      emit(state.copyWith(
        currentUrl: urlToSubmit,
        navigateToPreviewUrl: urlToSubmit,
        showSmartPaste: false,
      ));
    }
  }

  void _onSmartPasteDetected(
      SmartPasteDetected event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      showSmartPaste: true,
      smartPasteUrl: event.url,
      smartPastePlatform: event.platform,
    ));
  }

  void _onSmartPasteDismissed(
      SmartPasteDismissed event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      showSmartPaste: false,
      clearSmartPasteUrl: true,
      clearSmartPastePlatform: true,
    ));
  }

  Future<void> _checkClipboardInternal(Emitter<HomeState> emit) async {
    final result = await clipboardWatcher.checkClipboard();
    if (result != null) {
      emit(state.copyWith(
        showSmartPaste: true,
        smartPasteUrl: result.url,
        smartPastePlatform: result.platform,
      ));
    }
  }
}

