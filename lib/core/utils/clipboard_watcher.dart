import 'package:flutter/services.dart';
import '../enums/platform_type.dart';
import 'url_parser.dart';

class ClipboardWatcher {
  String? _lastClipboardContent;

  /// Checks the system clipboard and returns URL and platform if a new supported link is found.
  Future<({String url, PlatformType platform})?> checkClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();

    if (text == null || text.isEmpty || text == _lastClipboardContent) {
      return null;
    }
    _lastClipboardContent = text;

    final parsed = UrlParser.parse(text);
    if (parsed.isValid && parsed.platform != PlatformType.unknown) {
      return (url: parsed.normalizedUrl, platform: parsed.platform);
    }

    return null;
  }

  /// Clears last recorded clipboard content.
  void reset() {
    _lastClipboardContent = null;
  }
}

