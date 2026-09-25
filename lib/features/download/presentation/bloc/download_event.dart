import 'package:equatable/equatable.dart';
import '../../domain/entities/download_task.dart';
import '../../domain/entities/video_info.dart';
import '../../domain/entities/video_quality.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object?> get props => [];
}

class LoadDownloads extends DownloadEvent {
  const LoadDownloads();
}

class StartNewDownload extends DownloadEvent {
  final VideoInfo videoInfo;
  final VideoQuality quality;
  final bool isAudioOnly;

  const StartNewDownload({
    required this.videoInfo,
    required this.quality,
    this.isAudioOnly = false,
  });

  @override
  List<Object?> get props => [videoInfo, quality, isAudioOnly];
}

class PauseDownload extends DownloadEvent {
  final String taskId;

  const PauseDownload(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ResumeDownload extends DownloadEvent {
  final String taskId;

  const ResumeDownload(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class CancelDownload extends DownloadEvent {
  final String taskId;

  const CancelDownload(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class RetryDownload extends DownloadEvent {
  final String taskId;

  const RetryDownload(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DeleteDownload extends DownloadEvent {
  final String taskId;

  const DeleteDownload(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DownloadProgressUpdated extends DownloadEvent {
  final DownloadTask task;

  const DownloadProgressUpdated(this.task);

  @override
  List<Object?> get props => [task];
}

