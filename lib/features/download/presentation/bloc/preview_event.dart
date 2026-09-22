import 'package:equatable/equatable.dart';
import '../../domain/entities/video_quality.dart';

abstract class PreviewEvent extends Equatable {
  const PreviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchVideoInfoEvent extends PreviewEvent {
  final String url;
  const FetchVideoInfoEvent(this.url);

  @override
  List<Object?> get props => [url];
}

class SelectFormatEvent extends PreviewEvent {
  final bool isAudioOnly;
  const SelectFormatEvent(this.isAudioOnly);

  @override
  List<Object?> get props => [isAudioOnly];
}

class SelectQualityEvent extends PreviewEvent {
  final VideoQuality quality;
  const SelectQualityEvent(this.quality);

  @override
  List<Object?> get props => [quality];
}

class StartDownloadEvent extends PreviewEvent {
  const StartDownloadEvent();
}

