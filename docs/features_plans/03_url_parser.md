# 🔗 Feature 03: محلل الروابط واكتشاف المنصة

> المحرك الأساسي الذي يحلل روابط الفيديو، يحدد المنصة المصدر، ويستخرج معرّف الفيديو للتعامل مع كل منصة بالطريقة المناسبة.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🔴 عالية |
| **التبعيات** | Feature 01 (إعداد المشروع) |
| **المدة المتوقعة** | 2 أيام |
| **التعقيد** | متوسط |

---

## 🎯 الأهداف

1. تحليل أي رابط مدخل والتحقق من صحته
2. اكتشاف المنصة المصدر تلقائياً (YouTube, Instagram, TikTok, Twitter, Facebook)
3. استخراج معرّف الفيديو (Video ID) من كل منصة
4. دعم أشكال الروابط المختلفة لكل منصة (اختصارات، روابط مشاركة، روابط ويب)
5. إرجاع معلومات منظمة عن الرابط

---

## 📄 الملفات المطلوبة

```
lib/core/utils/
├── url_parser.dart              # المحلل الرئيسي
└── platform_patterns.dart       # أنماط الروابط لكل منصة

lib/core/models/
└── parsed_url.dart              # نموذج البيانات الناتج

test/core/utils/
└── url_parser_test.dart         # اختبارات شاملة
```

---

## 📄 التنفيذ التفصيلي

### 1. نموذج الرابط المحلل

```dart
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
```

### 2. أنماط الروابط لكل منصة

```dart
class PlatformPatterns {
  // ─── YouTube ───────────────────────────────────
  static final List<RegExp> youtube = [
    // https://www.youtube.com/watch?v=VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?youtube\.com/watch\?v=([\w-]{11})'),
    // https://youtu.be/VIDEO_ID
    RegExp(r'(?:https?://)?youtu\.be/([\w-]{11})'),
    // https://www.youtube.com/shorts/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?youtube\.com/shorts/([\w-]{11})'),
    // https://youtube.com/embed/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?youtube\.com/embed/([\w-]{11})'),
    // https://m.youtube.com/watch?v=VIDEO_ID
    RegExp(r'(?:https?://)?m\.youtube\.com/watch\?v=([\w-]{11})'),
    // https://music.youtube.com/watch?v=VIDEO_ID
    RegExp(r'(?:https?://)?music\.youtube\.com/watch\?v=([\w-]{11})'),
  ];

  // ─── Instagram ─────────────────────────────────
  static final List<RegExp> instagram = [
    // https://www.instagram.com/reel/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/reel/([\w-]+)'),
    // https://www.instagram.com/reels/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/reels/([\w-]+)'),
    // https://www.instagram.com/p/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/p/([\w-]+)'),
    // https://www.instagram.com/stories/USERNAME/ID/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/stories/[\w.]+/(\d+)'),
    // https://www.instagram.com/tv/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/tv/([\w-]+)'),
  ];

  // ─── TikTok ────────────────────────────────────
  static final List<RegExp> tiktok = [
    // https://www.tiktok.com/@user/video/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?tiktok\.com/@[\w.]+/video/(\d+)'),
    // https://vm.tiktok.com/CODE/
    RegExp(r'(?:https?://)?vm\.tiktok\.com/([\w-]+)'),
    // https://vt.tiktok.com/CODE/
    RegExp(r'(?:https?://)?vt\.tiktok\.com/([\w-]+)'),
    // https://www.tiktok.com/t/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?tiktok\.com/t/([\w-]+)'),
  ];

  // ─── Twitter/X ─────────────────────────────────
  static final List<RegExp> twitter = [
    // https://twitter.com/user/status/TWEET_ID
    RegExp(r'(?:https?://)?(?:www\.)?twitter\.com/\w+/status/(\d+)'),
    // https://x.com/user/status/TWEET_ID
    RegExp(r'(?:https?://)?(?:www\.)?x\.com/\w+/status/(\d+)'),
    // https://t.co/CODE
    RegExp(r'(?:https?://)?t\.co/([\w-]+)'),
  ];

  // ─── Facebook ──────────────────────────────────
  static final List<RegExp> facebook = [
    // https://www.facebook.com/watch/?v=VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/watch/\?v=(\d+)'),
    // https://www.facebook.com/user/videos/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/[\w.]+/videos/(\d+)'),
    // https://fb.watch/CODE/
    RegExp(r'(?:https?://)?fb\.watch/([\w-]+)'),
    // https://www.facebook.com/reel/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/reel/(\d+)'),
    // https://www.facebook.com/share/v/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/share/v/([\w-]+)'),
  ];
}
```

### 3. المحلل الرئيسي

```dart
class UrlParser {
  /// تحليل الرابط واستخراج جميع المعلومات
  static ParsedUrl parse(String input) {
    final url = input.trim();
    
    // التحقق الأساسي
    if (url.isEmpty) {
      return ParsedUrl.invalid(url, 'الرابط فارغ');
    }
    
    if (!_isValidUrl(url)) {
      return ParsedUrl.invalid(url, 'رابط غير صالح');
    }
    
    // محاولة مطابقة مع كل منصة
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

  /// اكتشاف المنصة فقط بدون تحليل كامل
  static PlatformType detectPlatform(String url) {
    return parse(url).platform;
  }

  /// التحقق من صحة الرابط
  static bool isValidUrl(String url) {
    return parse(url).isValid;
  }

  /// التحقق الأساسي من بنية الرابط
  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// تطبيع الرابط
  static String _normalizeUrl(String url) {
    var normalized = url.trim();
    if (!normalized.startsWith('http')) {
      normalized = 'https://$normalized';
    }
    // إزالة tracking parameters
    final uri = Uri.parse(normalized);
    final cleanParams = Map<String, String>.from(uri.queryParameters)
      ..removeWhere((key, _) => _trackingParams.contains(key));
    return uri.replace(queryParameters: cleanParams.isEmpty ? null : cleanParams).toString();
  }

  static const _trackingParams = [
    'utm_source', 'utm_medium', 'utm_campaign',
    'utm_term', 'utm_content', 'si', 'feature',
    'fbclid', 'igshid',
  ];

  static final Map<PlatformType, List<RegExp>> _platformMap = {
    PlatformType.youtube: PlatformPatterns.youtube,
    PlatformType.instagram: PlatformPatterns.instagram,
    PlatformType.tiktok: PlatformPatterns.tiktok,
    PlatformType.twitter: PlatformPatterns.twitter,
    PlatformType.facebook: PlatformPatterns.facebook,
  };
}
```

---

## 🧪 خطة الاختبار

```dart
group('UrlParser', () {
  // ─── YouTube ─────────────────────
  group('YouTube', () {
    test('standard watch URL', () {
      final result = UrlParser.parse('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
      expect(result.platform, PlatformType.youtube);
      expect(result.videoId, 'dQw4w9WgXcQ');
      expect(result.isValid, true);
    });
    
    test('short URL', () {
      final result = UrlParser.parse('https://youtu.be/dQw4w9WgXcQ');
      expect(result.platform, PlatformType.youtube);
      expect(result.videoId, 'dQw4w9WgXcQ');
    });
    
    test('shorts URL', () {
      final result = UrlParser.parse('https://youtube.com/shorts/dQw4w9WgXcQ');
      expect(result.platform, PlatformType.youtube);
    });
    
    test('mobile URL', () {
      final result = UrlParser.parse('https://m.youtube.com/watch?v=dQw4w9WgXcQ');
      expect(result.platform, PlatformType.youtube);
    });
    
    test('music URL', () {
      final result = UrlParser.parse('https://music.youtube.com/watch?v=dQw4w9WgXcQ');
      expect(result.platform, PlatformType.youtube);
    });
  });
  
  // ─── Instagram ───────────────────
  group('Instagram', () {
    test('reel URL', () {
      final result = UrlParser.parse('https://www.instagram.com/reel/ABC123/');
      expect(result.platform, PlatformType.instagram);
      expect(result.videoId, 'ABC123');
    });
    
    test('post URL', () {
      final result = UrlParser.parse('https://instagram.com/p/ABC123/');
      expect(result.platform, PlatformType.instagram);
    });
    
    test('story URL', () {
      final result = UrlParser.parse('https://instagram.com/stories/username/12345/');
      expect(result.platform, PlatformType.instagram);
    });
  });
  
  // ─── TikTok ──────────────────────
  group('TikTok', () {
    test('standard video URL', () {
      final result = UrlParser.parse('https://www.tiktok.com/@user/video/1234567890');
      expect(result.platform, PlatformType.tiktok);
      expect(result.videoId, '1234567890');
    });
    
    test('short share URL (vm)', () {
      final result = UrlParser.parse('https://vm.tiktok.com/ZMxxxxxx/');
      expect(result.platform, PlatformType.tiktok);
    });
    
    test('short share URL (vt)', () {
      final result = UrlParser.parse('https://vt.tiktok.com/ZMxxxxxx/');
      expect(result.platform, PlatformType.tiktok);
    });
  });
  
  // ─── Twitter/X ───────────────────
  group('Twitter/X', () {
    test('twitter.com URL', () {
      final result = UrlParser.parse('https://twitter.com/user/status/1234567890');
      expect(result.platform, PlatformType.twitter);
    });
    
    test('x.com URL', () {
      final result = UrlParser.parse('https://x.com/user/status/1234567890');
      expect(result.platform, PlatformType.twitter);
    });
  });
  
  // ─── Invalid URLs ────────────────
  group('Invalid', () {
    test('empty string', () {
      expect(UrlParser.parse('').isValid, false);
    });
    
    test('random text', () {
      expect(UrlParser.parse('hello world').isValid, false);
    });
    
    test('unsupported platform', () {
      final result = UrlParser.parse('https://www.google.com');
      expect(result.platform, PlatformType.unknown);
      expect(result.isValid, false);
    });
  });
  
  // ─── URL Normalization ───────────
  group('Normalization', () {
    test('removes tracking parameters', () {
      final result = UrlParser.parse(
        'https://youtube.com/watch?v=test&utm_source=share&si=xxx');
      expect(result.normalizedUrl, isNot(contains('utm_source')));
      expect(result.normalizedUrl, isNot(contains('si=')));
    });
    
    test('adds https if missing', () {
      final result = UrlParser.parse('youtube.com/watch?v=dQw4w9WgXcQ');
      expect(result.normalizedUrl, startsWith('https://'));
    });
  });
});
```

---

## ✅ معايير القبول

- [ ] يكتشف YouTube بجميع أشكال الروابط (watch, youtu.be, shorts, embed, mobile, music)
- [ ] يكتشف Instagram بجميع أشكال الروابط (reel, reels, post, story, tv)
- [ ] يكتشف TikTok بجميع أشكال الروابط (video, vm, vt, t)
- [ ] يكتشف Twitter/X بجميع أشكال الروابط (twitter.com, x.com, t.co)
- [ ] يكتشف Facebook بجميع أشكال الروابط (watch, videos, fb.watch, reel, share)
- [ ] يستخرج Video ID بنجاح من كل منصة
- [ ] يرفض الروابط غير الصالحة مع رسالة خطأ واضحة
- [ ] يزيل tracking parameters من الروابط
- [ ] جميع الاختبارات تمر بنجاح (25+ test case)
