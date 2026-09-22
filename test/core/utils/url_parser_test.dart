import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/utils/url_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UrlParser', () {
    group('YouTube', () {
      test('standard watch URL', () {
        final result = UrlParser.parse('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
        expect(result.isValid, true);
      });

      test('short youtu.be URL', () {
        final result = UrlParser.parse('https://youtu.be/dQw4w9WgXcQ');
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
      });

      test('shorts URL', () {
        final result = UrlParser.parse('https://www.youtube.com/shorts/dQw4w9WgXcQ');
        expect(result.platform, PlatformType.youtube);
      });

      test('mobile URL', () {
        final result = UrlParser.parse('https://m.youtube.com/watch?v=dQw4w9WgXcQ');
        expect(result.platform, PlatformType.youtube);
      });
    });

    group('Instagram', () {
      test('reel URL', () {
        final result = UrlParser.parse('https://www.instagram.com/reel/C3abc123_xyz/');
        expect(result.platform, PlatformType.instagram);
        expect(result.videoId, 'C3abc123_xyz');
        expect(result.isValid, true);
      });

      test('post URL', () {
        final result = UrlParser.parse('https://www.instagram.com/p/C3abc123/');
        expect(result.platform, PlatformType.instagram);
      });
    });

    group('TikTok', () {
      test('standard video URL', () {
        final result =
            UrlParser.parse('https://www.tiktok.com/@user.name/video/1234567890123456789');
        expect(result.platform, PlatformType.tiktok);
        expect(result.videoId, '1234567890123456789');
        expect(result.isValid, true);
      });

      test('short vm share URL', () {
        final result = UrlParser.parse('https://vm.tiktok.com/ZMxxxxxx/');
        expect(result.platform, PlatformType.tiktok);
        expect(result.videoId, 'ZMxxxxxx');
      });
    });

    group('Twitter / X', () {
      test('twitter.com status URL', () {
        final result = UrlParser.parse('https://twitter.com/user/status/1234567890');
        expect(result.platform, PlatformType.twitter);
        expect(result.videoId, '1234567890');
      });

      test('x.com status URL', () {
        final result = UrlParser.parse('https://x.com/user/status/1234567890');
        expect(result.platform, PlatformType.twitter);
      });
    });

    group('Facebook', () {
      test('facebook watch URL', () {
        final result = UrlParser.parse('https://www.facebook.com/watch/?v=1234567890');
        expect(result.platform, PlatformType.facebook);
        expect(result.videoId, '1234567890');
      });

      test('fb.watch URL', () {
        final result = UrlParser.parse('https://fb.watch/abcdef123/');
        expect(result.platform, PlatformType.facebook);
      });
    });

    group('Invalid URLs', () {
      test('empty string is invalid', () {
        expect(UrlParser.parse('').isValid, false);
      });

      test('non-supported website is invalid', () {
        final result = UrlParser.parse('https://www.google.com');
        expect(result.isValid, false);
        expect(result.platform, PlatformType.unknown);
      });

      test('arbitrary text is invalid', () {
        expect(UrlParser.parse('not a link').isValid, false);
      });
    });

    group('Normalization', () {
      test('strips tracking parameters like utm and si', () {
        final result = UrlParser.parse(
            'https://youtube.com/watch?v=dQw4w9WgXcQ&utm_source=share&si=abc123xyz');
        expect(result.normalizedUrl, isNot(contains('utm_source')));
        expect(result.normalizedUrl, isNot(contains('si=')));
      });
    });
  });
}

