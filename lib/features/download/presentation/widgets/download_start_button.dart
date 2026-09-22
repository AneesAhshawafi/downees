import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/video_quality.dart';

class DownloadStartButton extends StatelessWidget {
  final VideoQuality? selectedQuality;
  final VoidCallback? onStartDownload;

  const DownloadStartButton({
    super.key,
    required this.selectedQuality,
    required this.onStartDownload,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sizeText = selectedQuality != null ? ' (${selectedQuality!.fileSizeMB} MB)' : '';

    return ElevatedButton.icon(
      onPressed: selectedQuality != null ? onStartDownload : null,
      icon: const Icon(Icons.download_rounded, size: AppDimensions.iconMd),
      label: Text(
        '${l10n?.downloadNow ?? 'Download Now'}$sizeText',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

