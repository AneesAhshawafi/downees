import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/utils/url_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UrlParser', () {
    // ─── YouTube ─────────────────────────────────────────────────────────────
    group('YouTube', () {
      test('standard watch URL', () {
        final result = UrlParser.parse(
          'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        );
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
        expect(result.isValid, true);
      });

      test('short youtu.be URL', () {
        final result = UrlParser.parse('https://youtu.be/dQw4w9WgXcQ');
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
        expect(result.isValid, true);
      });

      test('shorts URL', () {
        final result = UrlParser.parse(
          'https://www.youtube.com/shorts/dQw4w9WgXcQ',
        );
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
        expect(result.isValid, true);
      });

      test('embed URL', () {
        final result = UrlParser.parse('https://youtube.com/embed/dQw4w9WgXcQ');
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
        expect(result.isValid, true);
      });

      test('mobile URL', () {
        final result = UrlParser.parse(
          'https://m.youtube.com/watch?v=dQw4w9WgXcQ',
        );
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
        expect(result.isValid, true);
      });

      test('music URL', () {
        final result = UrlParser.parse(
          'https://music.youtube.com/watch?v=dQw4w9WgXcQ',
        );
        expect(result.platform, PlatformType.youtube);
        expect(result.videoId, 'dQw4w9WgXcQ');
        expect(result.isValid, true);
      });
    });

    // ─── Instagram ───────────────────────────────────────────────────────────
    group('Instagram', () {
      test('reel URL', () {
        final result = UrlParser.parse(
          'https://www.instagram.com/reel/ABC123/',
        );
        expect(result.platform, PlatformType.instagram);
        expect(result.videoId, 'ABC123');
        expect(result.isValid, true);
      });

      test('reels URL', () {
        final result = UrlParser.parse(
          'https://www.instagram.com/reels/ABC123/',
        );
        expect(result.platform, PlatformType.instagram);
        expect(result.videoId, 'ABC123');
        expect(result.isValid, true);
      });

      test('post URL', () {
        final result = UrlParser.parse('https://instagram.com/p/ABC123/');
        expect(result.platform, PlatformType.instagram);
        expect(result.videoId, 'ABC123');
        expect(result.isValid, true);
      });

      test('story URL', () {
        final result = UrlParser.parse(
          'https://instagram.com/stories/username/123456789/',
        );
        expect(result.platform, PlatformType.instagram);
        expect(result.videoId, '123456789');
        expect(result.isValid, true);
      });

      test('tv URL', () {
        final result = UrlParser.parse('https://www.instagram.com/tv/ABC123/');
        expect(result.platform, PlatformType.instagram);
        expect(result.videoId, 'ABC123');
        expect(result.isValid, true);
      });
    });

    // ─── TikTok ──────────────────────────────────────────────────────────────
    group('TikTok', () {
      test('standard video URL', () {
        final result = UrlParser.parse(
          'https://www.tiktok.com/@user.name/video/1234567890',
        );
        expect(result.platform, PlatformType.tiktok);
        expect(result.videoId, '1234567890');
        expect(result.isValid, true);
      });

      test('short vm share URL', () {
        final result = UrlParser.parse('https://vm.tiktok.com/ZMxxxxxx/');
        expect(result.platform, PlatformType.tiktok);
        expect(result.videoId, 'ZMxxxxxx');
        expect(result.isValid, true);
      });

      test('short vt share URL', () {
        final result = UrlParser.parse('https://vt.tiktok.com/ZMxxxxxx/');
        expect(result.platform, PlatformType.tiktok);
        expect(result.videoId, 'ZMxxxxxx');
        expect(result.isValid, true);
      });

      test('tiktok.com/t/ share URL', () {
        final result = UrlParser.parse('https://www.tiktok.com/t/ZMxxxxxx/');
        expect(result.platform, PlatformType.tiktok);
        expect(result.videoId, 'ZMxxxxxx');
        expect(result.isValid, true);
      });
    });

    // ─── Twitter / X ─────────────────────────────────────────────────────────
    group('Twitter / X', () {
      test('twitter.com status URL', () {
        final result = UrlParser.parse(
          'https://twitter.com/elonmusk/status/1234567890123456789',
        );
        expect(result.platform, PlatformType.twitter);
        expect(result.videoId, '1234567890123456789');
        expect(result.isValid, true);
      });

      test('x.com status URL', () {
        final result = UrlParser.parse('https://x.com/user/status/1234567890');
        expect(result.platform, PlatformType.twitter);
        expect(result.videoId, '1234567890');
        expect(result.isValid, true);
      });

      test('t.co short URL', () {
        final result = UrlParser.parse('https://t.co/ABC123xyz');
        expect(result.platform, PlatformType.twitter);
        expect(result.videoId, 'ABC123xyz');
        expect(result.isValid, true);
      });
    });

    // ─── Facebook ────────────────────────────────────────────────────────────
    group('Facebook', () {
      test('facebook watch URL', () {
        final result = UrlParser.parse(
          'https://www.facebook.com/watch/?v=1234567890',
        );
        expect(result.platform, PlatformType.facebook);
        expect(result.videoId, '1234567890');
        expect(result.isValid, true);
      });

      test('facebook user videos URL', () {
        final result = UrlParser.parse(
          'https://www.facebook.com/username/videos/1234567890',
        );
        expect(result.platform, PlatformType.facebook);
        expect(result.videoId, '1234567890');
        expect(result.isValid, true);
      });

      test('fb.watch URL', () {
        final result = UrlParser.parse('https://fb.watch/ABC123xyz/');
        expect(result.platform, PlatformType.facebook);
        expect(result.videoId, 'ABC123xyz');
        expect(result.isValid, true);
      });

      test('facebook reel URL', () {
        final result = UrlParser.parse(
          'https://www.facebook.com/reel/1234567890',
        );
        expect(result.platform, PlatformType.facebook);
        expect(result.videoId, '1234567890');
        expect(result.isValid, true);
      });

      test('facebook share URL', () {
        final result = UrlParser.parse(
          'https://www.facebook.com/share/v/ABC123xyz/',
        );
        expect(result.platform, PlatformType.facebook);
        expect(result.videoId, 'ABC123xyz');
        expect(result.isValid, true);
      });
    });

    // ─── Invalid URLs ────────────────────────────────────────────────────────
    group('Invalid', () {
      test('empty string', () {
        final result = UrlParser.parse('');
        expect(result.isValid, false);
        expect(result.platform, PlatformType.unknown);
        expect(result.errorMessage, isNotNull);
      });

      test('random text', () {
        final result = UrlParser.parse('hello world this is not a link');
        expect(result.isValid, false);
        expect(result.platform, PlatformType.unknown);
      });

      test('unsupported platform', () {
        final result = UrlParser.parse('https://www.google.com');
        expect(result.platform, PlatformType.unknown);
        expect(result.isValid, false);
      });
    });

    // ─── Normalization & Utilities ───────────────────────────────────────────
    group('Normalization & Utilities', () {
      test('removes tracking parameters', () {
        final result = UrlParser.parse(
          'https://youtube.com/watch?v=dQw4w9WgXcQ&utm_source=share&utm_medium=ios_app&si=xxx&fbclid=yyy',
        );
        expect(result.normalizedUrl, isNot(contains('utm_source')));
        expect(result.normalizedUrl, isNot(contains('utm_medium')));
        expect(result.normalizedUrl, isNot(contains('si=')));
        expect(result.normalizedUrl, isNot(contains('fbclid=')));
      });

      test('adds https if missing', () {
        final result = UrlParser.parse('youtube.com/watch?v=dQw4w9WgXcQ');
        expect(result.normalizedUrl, startsWith('https://'));
        expect(result.isValid, true);
      });

      test('detectPlatform helper returns correct platform', () {
        expect(
          UrlParser.detectPlatform('https://youtu.be/dQw4w9WgXcQ'),
          PlatformType.youtube,
        );
        expect(
          UrlParser.detectPlatform('https://vm.tiktok.com/ZMxxxxxx/'),
          PlatformType.tiktok,
        );
        expect(
          UrlParser.detectPlatform('https://www.google.com'),
          PlatformType.unknown,
        );
      });

      test(
        'isValidUrl helper returns true for valid and false for invalid',
        () {
          expect(
            UrlParser.isValidUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
            true,
          );
          expect(
            UrlParser.isValidUrl('https://unknown-site.org/video/123'),
            false,
          );
        },
      );
    });
  });
}
