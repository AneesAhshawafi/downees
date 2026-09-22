import '../enums/platform_type.dart';
import '../models/parsed_url.dart';
import 'platform_patterns.dart';

class UrlParser {
  UrlParser._();

  static const _trackingParams = [
    'utm_source',
    'utm_medium',
    'utm_campaign',
    'utm_term',
    'utm_content',
    'si',
    'feature',
    'fbclid',
    'igshid',
  ];

  static final Map<PlatformType, List<RegExp>> _platformMap = {
    PlatformType.youtube: PlatformPatterns.youtube,
    PlatformType.instagram: PlatformPatterns.instagram,
    PlatformType.tiktok: PlatformPatterns.tiktok,
    PlatformType.twitter: PlatformPatterns.twitter,
    PlatformType.facebook: PlatformPatterns.facebook,
  };

  /// Parse the input URL and extract platform, video ID, and normalized URL.
  static ParsedUrl parse(String input) {
    final url = input.trim();

    if (url.isEmpty) {
      return ParsedUrl.invalid(url, 'الرابط فارغ');
    }

    if (!_isValidUrl(url)) {
      return ParsedUrl.invalid(url, 'رابط غير صالح');
    }

    for (final entry in _platformMap.entries) {
      for (final pattern in entry.value) {
        final match = pattern.firstMatch(url);
        if (match != null) {
          return ParsedUrl(
            originalUrl: url,
            normalizedUrl: _normalizeUrl(url),
            platform: entry.key,
            videoId: match.groupCount >= 1 ? match.group(1) : null,
            isValid: true,
          );
        }
      }
    }

    return ParsedUrl.invalid(url, 'منصة غير مدعومة');
  }

  /// Detect platform type directly from URL.
  static PlatformType detectPlatform(String url) {
    return parse(url).platform;
  }

  /// Returns true if the URL matches any supported platform.
  static bool isValidUrl(String url) {
    return parse(url).isValid;
  }

  static bool _isValidUrl(String url) {
    try {
      final normalized = url.startsWith('http://') || url.startsWith('https://')
          ? url
          : 'https://$url';
      final uri = Uri.parse(normalized);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static String _normalizeUrl(String url) {
    var normalized = url.trim();
    if (!normalized.startsWith('http://') && !normalized.startsWith('https://')) {
      normalized = 'https://$normalized';
    }

    try {
      final uri = Uri.parse(normalized);
      final cleanParams = Map<String, String>.from(uri.queryParameters)
        ..removeWhere((key, _) => _trackingParams.contains(key.toLowerCase()));

      return uri
          .replace(queryParameters: cleanParams.isEmpty ? null : cleanParams)
          .toString();
    } catch (_) {
      return normalized;
    }
  }
}

