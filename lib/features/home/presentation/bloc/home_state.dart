import 'package:equatable/equatable.dart';
import '../../../../core/enums/platform_type.dart';
import '../../../download/domain/entities/download_task.dart';

class HomeState extends Equatable {
  final String currentUrl;
  final PlatformType? detectedPlatform;
  final bool isValidUrl;
  final bool showSmartPaste;
  final String? smartPasteUrl;
  final PlatformType? smartPastePlatform;
  final List<DownloadTask> activeDownloads;
  final String? navigateToPreviewUrl;

  const HomeState({
    this.currentUrl = '',
    this.detectedPlatform,
    this.isValidUrl = false,
    this.showSmartPaste = false,
    this.smartPasteUrl,
    this.smartPastePlatform,
    this.activeDownloads = const [],
    this.navigateToPreviewUrl,
  });

  HomeState copyWith({
    String? currentUrl,
    PlatformType? detectedPlatform,
    bool clearDetectedPlatform = false,
    bool? isValidUrl,
    bool? showSmartPaste,
    String? smartPasteUrl,
    bool clearSmartPasteUrl = false,
    PlatformType? smartPastePlatform,
    bool clearSmartPastePlatform = false,
    List<DownloadTask>? activeDownloads,
    String? navigateToPreviewUrl,
    bool clearNavigateToPreview = false,
  }) {
    return HomeState(
      currentUrl: currentUrl ?? this.currentUrl,
      detectedPlatform: clearDetectedPlatform ? null : (detectedPlatform ?? this.detectedPlatform),
      isValidUrl: isValidUrl ?? this.isValidUrl,
      showSmartPaste: showSmartPaste ?? this.showSmartPaste,
      smartPasteUrl: clearSmartPasteUrl ? null : (smartPasteUrl ?? this.smartPasteUrl),
      smartPastePlatform: clearSmartPastePlatform ? null : (smartPastePlatform ?? this.smartPastePlatform),
      activeDownloads: activeDownloads ?? this.activeDownloads,
      navigateToPreviewUrl: clearNavigateToPreview ? null : (navigateToPreviewUrl ?? this.navigateToPreviewUrl),
    );
  }

  @override
  List<Object?> get props => [
        currentUrl,
        detectedPlatform,
        isValidUrl,
        showSmartPaste,
        smartPasteUrl,
        smartPastePlatform,
        activeDownloads,
        navigateToPreviewUrl,
      ];
}

