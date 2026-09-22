import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';

class DownloadPreviewPage extends StatelessWidget {
  final String url;

  const DownloadPreviewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.preview),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.pasteLink,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      SelectableText(
                        url,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Handled in Feature 04/05
                },
                icon: const Icon(Icons.download),
                label: Text(l10n.downloadNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

