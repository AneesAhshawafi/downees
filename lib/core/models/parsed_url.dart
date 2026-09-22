import '../enums/platform_type.dart';

class ParsedUrl {
  final String originalUrl;
  final String normalizedUrl;
  final PlatformType platform;
  final String? videoId;
  final bool isValid;
  final String? errorMessage;

  const ParsedUrl({
    required this.originalUrl,
    required this.normalizedUrl,
    required this.platform,
    this.videoId,
    required this.isValid,
    this.errorMessage,
  });

  factory ParsedUrl.invalid(String url, String error) => ParsedUrl(
        originalUrl: url,
        normalizedUrl: url,
        platform: PlatformType.unknown,
        isValid: false,
        errorMessage: error,
      );
}

