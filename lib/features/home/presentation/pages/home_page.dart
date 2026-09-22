import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _onDownloadPressed() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      context.push('/preview', extra: url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.md),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: l10n.pasteLink,
                  prefixIcon: const Icon(Icons.link),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.paste),
                    tooltip: l10n.paste,
                    onPressed: () {
                      // Handled more comprehensively in Feature 02
                    },
                  ),
                ),
                onSubmitted: (_) => _onDownloadPressed(),
              ),
              const SizedBox(height: AppDimensions.md),
              ElevatedButton.icon(
                onPressed: _onDownloadPressed,
                icon: const Icon(Icons.download),
                label: Text(l10n.download),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

