import 'package:equatable/equatable.dart';
import '../../../../core/enums/download_status.dart';
import '../../domain/entities/video_info.dart';
import '../../domain/entities/video_quality.dart';

class PreviewState extends Equatable {
  final VideoInfo? videoInfo;
  final bool isLoading;
  final String? error;
  final bool isAudioOnly;
  final VideoQuality? selectedQuality;
  final DownloadStatus downloadStatus;

  const PreviewState({
    this.videoInfo,
    this.isLoading = false,
    this.error,
    this.isAudioOnly = false,
    this.selectedQuality,
    this.downloadStatus = DownloadStatus.ready,
  });

  List<VideoQuality> get currentQualities {
    if (videoInfo == null) return [];
    return isAudioOnly ? videoInfo!.audioQualities : videoInfo!.qualities;
  }

  PreviewState copyWith({
    VideoInfo? videoInfo,
    bool clearVideoInfo = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? isAudioOnly,
    VideoQuality? selectedQuality,
    bool clearSelectedQuality = false,
    DownloadStatus? downloadStatus,
  }) {
    return PreviewState(
      videoInfo: clearVideoInfo ? null : (videoInfo ?? this.videoInfo),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isAudioOnly: isAudioOnly ?? this.isAudioOnly,
      selectedQuality: clearSelectedQuality
          ? null
          : (selectedQuality ?? this.selectedQuality),
      downloadStatus: downloadStatus ?? this.downloadStatus,
    );
  }

  @override
  List<Object?> get props => [
        videoInfo,
        isLoading,
        error,
        isAudioOnly,
        selectedQuality,
        downloadStatus,
      ];
}

