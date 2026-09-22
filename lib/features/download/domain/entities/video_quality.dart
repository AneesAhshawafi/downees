import 'package:equatable/equatable.dart';

class VideoQuality extends Equatable {
  final String label;
  final String? resolution;
  final int fileSizeBytes;
  final String downloadUrl;
  final String format;
  final bool hasAudio;
  final bool isAudioOnly;

  const VideoQuality({
    required this.label,
    this.resolution,
    required this.fileSizeBytes,
    required this.downloadUrl,
    required this.format,
    this.hasAudio = true,
    this.isAudioOnly = false,
  });

  String get fileSizeMB => (fileSizeBytes / 1024 / 1024).toStringAsFixed(1);

  bool get isRecommended {
    if (isAudioOnly) {
      return label.contains('128') ||
          label.contains('130') ||
          label.contains('131') ||
          label.contains('160') ||
          label.contains('256') ||
          label.contains('320');
    }
    return label == '720p';
  }

  @override
  List<Object?> get props => [
    label,
    resolution,
    fileSizeBytes,
    downloadUrl,
    format,
    hasAudio,
    isAudioOnly,
  ];
}
