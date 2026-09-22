import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/download_status.dart';
import '../../domain/entities/video_quality.dart';
import '../../domain/usecases/fetch_video_info.dart';
import 'preview_event.dart';
import 'preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  final FetchVideoInfo fetchVideoInfo;

  PreviewBloc({required this.fetchVideoInfo}) : super(const PreviewState()) {
    on<FetchVideoInfoEvent>(_onFetchVideoInfo);
    on<SelectFormatEvent>(_onSelectFormat);
    on<SelectQualityEvent>(_onSelectQuality);
    on<StartDownloadEvent>(_onStartDownload);
  }

  Future<void> _onFetchVideoInfo(
    FetchVideoInfoEvent event,
    Emitter<PreviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final info = await fetchVideoInfo(event.url);
      final initialQuality = info.defaultQuality ??
          (info.qualities.isNotEmpty ? info.qualities.first : null);

      emit(state.copyWith(
        isLoading: false,
        videoInfo: info,
        selectedQuality: initialQuality,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onSelectFormat(
    SelectFormatEvent event,
    Emitter<PreviewState> emit,
  ) {
    if (state.videoInfo == null) return;

    final targetQualities = event.isAudioOnly
        ? state.videoInfo!.audioQualities
        : state.videoInfo!.qualities;

    VideoQuality? newSelected;
    if (targetQualities.isNotEmpty) {
      for (final q in targetQualities) {
        if (q.isRecommended) {
          newSelected = q;
          break;
        }
      }
      newSelected ??= targetQualities.first;
    }

    emit(state.copyWith(
      isAudioOnly: event.isAudioOnly,
      selectedQuality: newSelected,
      clearSelectedQuality: newSelected == null,
    ));
  }

  void _onSelectQuality(
    SelectQualityEvent event,
    Emitter<PreviewState> emit,
  ) {
    emit(state.copyWith(selectedQuality: event.quality));
  }

  void _onStartDownload(
    StartDownloadEvent event,
    Emitter<PreviewState> emit,
  ) {
    emit(state.copyWith(downloadStatus: DownloadStatus.downloading));
  }
}

