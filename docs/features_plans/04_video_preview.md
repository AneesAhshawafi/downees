# 🎬 Feature 04: معاينة الفيديو واختيار الجودة

> بعد لصق الرابط، تعرض هذه الصفحة معاينة كاملة للفيديو مع معلوماته، وتتيح للمستخدم اختيار الجودة والصيغة قبل بدء التحميل.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🔴 عالية |
| **التبعيات** | Feature 01, 03 (URL Parser) |
| **المدة المتوقعة** | 4-5 أيام |
| **التعقيد** | عالي |

---

## 🎯 الأهداف

1. جلب معلومات الفيديو من الـ Backend (عنوان، صورة مصغرة، مدة، الجودات المتاحة)
2. عرض صفحة معاينة جذابة بمعلومات الفيديو
3. اختيار الجودة بشكل بصري مع عرض حجم الملف المتوقع
4. التبديل بين تحميل فيديو أو صوت فقط (MP3)
5. زر بدء التحميل

---

## 🖼️ تصور الواجهة

```
╔══════════════════════════════════════╗
║  ← معاينة الفيديو                    ║
╠══════════════════════════════════════╣
║                                      ║
║  ┌────────────────────────────────┐  ║
║  │                                │  ║
║  │      🖼️ صورة مصغرة كبيرة      │  ║
║  │          ▶️ 03:45              │  ║
║  │                                │  ║
║  └────────────────────────────────┘  ║
║                                      ║
║  📹 عنوان الفيديو الكامل هنا        ║
║  👤 اسم القناة / الحساب              ║
║  👁️ 1.2M views • 📅 2024-01-15     ║
║                                      ║
║  ═══ نوع التحميل ══════════════════  ║
║                                      ║
║  ┌──────────┐  ┌──────────────┐      ║
║  │ 🎬 فيديو │  │ 🎵 صوت فقط  │      ║
║  │  (نشط)   │  │              │      ║
║  └──────────┘  └──────────────┘      ║
║                                      ║
║  ═══ اختر الجودة ══════════════════  ║
║                                      ║
║  ┌────────┐ ┌────────┐ ┌────────┐    ║
║  │  360p  │ │  720p  │ │ 1080p  │    ║
║  │  12MB  │ │  35MB  │ │  85MB  │    ║
║  │        │ │ ⭐ أفضل │ │        │    ║
║  └────────┘ └────────┘ └────────┘    ║
║                                      ║
║  ┌────────────────────────────────┐  ║
║  │     ⬇️  بدء التحميل (35 MB)    │  ║
║  └────────────────────────────────┘  ║
║                                      ║
╚══════════════════════════════════════╝
```

---

## 📄 الملفات المطلوبة

```
lib/features/download/
├── data/
│   ├── models/
│   │   └── video_info_model.dart       # JSON → Model
│   ├── datasources/
│   │   └── video_api_datasource.dart   # طلبات API
│   └── repositories/
│       └── video_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── video_info.dart             # Entity
│   │   └── video_quality.dart          # جودة الفيديو
│   ├── repositories/
│   │   └── video_repository.dart       # Abstract
│   └── usecases/
│       └── fetch_video_info.dart       # UseCase
└── presentation/
    ├── pages/
    │   └── download_preview_page.dart
    ├── widgets/
    │   ├── video_thumbnail.dart         # الصورة المصغرة
    │   ├── video_info_section.dart      # معلومات الفيديو
    │   ├── format_toggle.dart           # تبديل فيديو/صوت
    │   ├── quality_selector.dart        # اختيار الجودة
    │   ├── quality_chip.dart            # بطاقة جودة واحدة
    │   └── download_start_button.dart   # زر بدء التحميل
    └── bloc/
        ├── preview_bloc.dart
        ├── preview_event.dart
        └── preview_state.dart
```

---

## 📄 التنفيذ التفصيلي

### 1. الكيانات (Entities)

```dart
// video_quality.dart
class VideoQuality {
  final String label;        // "720p", "1080p"
  final String resolution;   // "1280x720"
  final int fileSizeBytes;   // حجم الملف بالبايت
  final String downloadUrl;  // رابط التحميل المباشر
  final String format;       // "mp4", "webm"
  final bool hasAudio;       // هل يحتوي صوت؟
  
  String get fileSizeMB => (fileSizeBytes / 1024 / 1024).toStringAsFixed(1);
  
  bool get isRecommended => label == '720p'; // الجودة المقترحة
}

// video_info.dart
class VideoInfo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelName;
  final String channelAvatarUrl;
  final Duration duration;
  final int viewCount;
  final DateTime? publishDate;
  final PlatformType platform;
  final List<VideoQuality> qualities;     // جودات الفيديو المتاحة
  final List<VideoQuality> audioQualities; // جودات الصوت المتاحة
  
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  String get formattedViews {
    if (viewCount >= 1000000) return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    if (viewCount >= 1000) return '${(viewCount / 1000).toStringAsFixed(1)}K';
    return viewCount.toString();
  }
}
```

### 2. نموذج البيانات (Model)

```dart
class VideoInfoModel extends VideoInfo {
  VideoInfoModel({
    required super.id,
    required super.title,
    // ... all fields
  });

  factory VideoInfoModel.fromJson(Map<String, dynamic> json) {
    return VideoInfoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail'],
      channelName: json['channel'] ?? '',
      channelAvatarUrl: json['channel_avatar'] ?? '',
      duration: Duration(seconds: json['duration'] ?? 0),
      viewCount: json['view_count'] ?? 0,
      publishDate: json['upload_date'] != null 
        ? DateTime.tryParse(json['upload_date']) 
        : null,
      platform: PlatformType.values.firstWhere(
        (p) => p.name == json['platform'],
        orElse: () => PlatformType.unknown,
      ),
      qualities: (json['formats'] as List? ?? [])
        .where((f) => f['vcodec'] != 'none')
        .map((f) => VideoQuality.fromJson(f))
        .toList(),
      audioQualities: (json['formats'] as List? ?? [])
        .where((f) => f['vcodec'] == 'none' && f['acodec'] != 'none')
        .map((f) => VideoQuality.fromJson(f))
        .toList(),
    );
  }
}
```

### 3. API DataSource

```dart
class VideoApiDatasource {
  final Dio _dio;
  
  VideoApiDatasource(this._dio);
  
  /// جلب معلومات الفيديو من Backend
  Future<VideoInfoModel> fetchVideoInfo(String url) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/video-info',
        data: {'url': url},
      );
      return VideoInfoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }
}
```

### 4. Preview BLoC

#### Events
```dart
abstract class PreviewEvent extends Equatable {}

class FetchVideoInfo extends PreviewEvent {
  final String url;
  FetchVideoInfo(this.url);
}

class SelectFormat extends PreviewEvent {    // فيديو أو صوت
  final bool isAudioOnly;
  SelectFormat(this.isAudioOnly);
}

class SelectQuality extends PreviewEvent {
  final VideoQuality quality;
  SelectQuality(this.quality);
}

class StartDownload extends PreviewEvent {}
```

#### States
```dart
class PreviewState extends Equatable {
  final VideoInfo? videoInfo;
  final bool isLoading;
  final String? error;
  final bool isAudioOnly;
  final VideoQuality? selectedQuality;
  final DownloadStatus downloadStatus;
}
```

### 5. صفحة المعاينة

```dart
class DownloadPreviewPage extends StatelessWidget {
  final String url;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PreviewBloc>()..add(FetchVideoInfo(url)),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.preview)),
        body: BlocBuilder<PreviewBloc, PreviewState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const _LoadingView();    // شاشة تحميل مع Shimmer
            }
            if (state.error != null) {
              return _ErrorView(error: state.error!);
            }
            return _ContentView(state: state);
          },
        ),
      ),
    );
  }
}
```

### 6. اختيار الجودة (Quality Selector)

```dart
class QualitySelector extends StatelessWidget {
  final List<VideoQuality> qualities;
  final VideoQuality? selected;
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: qualities.map((q) => QualityChip(
        quality: q,
        isSelected: q == selected,
        onTap: () => context.read<PreviewBloc>().add(SelectQuality(q)),
      )).toList(),
    );
  }
}

class QualityChip extends StatelessWidget {
  final VideoQuality quality;
  final bool isSelected;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
            ? null
            : Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quality.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${quality.fileSizeMB} MB',
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.grey,
              ),
            ),
            if (quality.isRecommended) ...[
              const SizedBox(height: 4),
              Text(
                '⭐ أفضل',
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.amber : Colors.amber[700],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### 7. تبديل الصيغة (Format Toggle)

```dart
class FormatToggle extends StatelessWidget {
  final bool isAudioOnly;
  
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: [
        ButtonSegment(
          value: false,
          icon: const Icon(Icons.videocam),
          label: Text(context.l10n.video),
        ),
        ButtonSegment(
          value: true,
          icon: const Icon(Icons.music_note),
          label: Text(context.l10n.audioOnly),
        ),
      ],
      selected: {isAudioOnly},
      onSelectionChanged: (value) => context
        .read<PreviewBloc>()
        .add(SelectFormat(value.first)),
    );
  }
}
```

---

## 🎨 تفاصيل التصميم

### حالة التحميل (Loading State)
- استخدام **Shimmer Effect** بدلاً من spinner عادي
- Skeleton للصورة المصغرة + الأسطر النصية + أزرار الجودة

### حالة الخطأ (Error State)
- أنيميشن Lottie لحالة الخطأ
- رسالة واضحة حسب نوع الخطأ:
  - "لا يوجد اتصال بالإنترنت" ← أيقونة WiFi Off
  - "الفيديو غير متاح" ← أيقونة Video Off
  - "منصة غير مدعومة" ← أيقونة Warning
- زر "إعادة المحاولة"

### الأنيميشن
- Hero animation للصورة المصغرة (من بطاقة Smart Paste)
- AnimatedContainer لاختيار الجودة
- AnimatedSize لعرض/إخفاء تفاصيل إضافية

---

## 🔗 Backend API المتوقع

### Request
```http
POST /api/video-info
Content-Type: application/json

{
  "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
}
```

### Response
```json
{
  "id": "dQw4w9WgXcQ",
  "title": "Rick Astley - Never Gonna Give You Up",
  "description": "...",
  "thumbnail": "https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
  "channel": "Rick Astley",
  "channel_avatar": "https://...",
  "duration": 212,
  "view_count": 1500000000,
  "upload_date": "2009-10-25",
  "platform": "youtube",
  "formats": [
    {
      "label": "360p",
      "resolution": "640x360",
      "filesize": 12582912,
      "url": "https://direct-download-url...",
      "format": "mp4",
      "vcodec": "avc1",
      "acodec": "mp4a"
    },
    {
      "label": "720p",
      "resolution": "1280x720",
      "filesize": 36700160,
      "url": "https://direct-download-url...",
      "format": "mp4",
      "vcodec": "avc1",
      "acodec": "mp4a"
    },
    {
      "label": "MP3 128kbps",
      "resolution": null,
      "filesize": 4194304,
      "url": "https://direct-download-url...",
      "format": "mp3",
      "vcodec": "none",
      "acodec": "mp4a"
    }
  ]
}
```

---

## ✅ معايير القبول

- [ ] عند فتح صفحة المعاينة، يتم جلب معلومات الفيديو وعرضها
- [ ] الصورة المصغرة تظهر بشكل صحيح مع مدة الفيديو
- [ ] عنوان الفيديو واسم القناة والمشاهدات تظهر بشكل صحيح
- [ ] يمكن التبديل بين فيديو وصوت فقط
- [ ] عند اختيار فيديو: تظهر جودات الفيديو (360p, 720p, 1080p...)
- [ ] عند اختيار صوت: تظهر جودات الصوت (128kbps, 256kbps...)
- [ ] كل جودة تعرض حجم الملف المتوقع
- [ ] الجودة المقترحة (720p) تكون محددة بشكل افتراضي مع علامة ⭐
- [ ] زر التحميل يعرض الحجم المتوقع ويبدأ عملية التحميل
- [ ] Shimmer effect يظهر أثناء التحميل
- [ ] رسائل خطأ واضحة مع زر إعادة المحاولة
- [ ] الواجهة تعمل في RTL و LTR

---

## 🧪 خطة الاختبار

```dart
group('PreviewBloc', () {
  test('should fetch video info successfully', () {
    bloc.add(FetchVideoInfo('https://youtube.com/watch?v=test'));
    expect(
      bloc.stream,
      emitsInOrder([
        isA<PreviewState>().having((s) => s.isLoading, 'loading', true),
        isA<PreviewState>().having((s) => s.videoInfo, 'info', isNotNull),
      ]),
    );
  });
  
  test('should toggle format between video and audio', () {
    bloc.add(SelectFormat(true));
    expect(bloc.state.isAudioOnly, true);
  });
  
  test('should select quality', () {
    final quality = VideoQuality(label: '720p', ...);
    bloc.add(SelectQuality(quality));
    expect(bloc.state.selectedQuality, quality);
  });
  
  test('should show error when API fails', () {
    when(repo.fetchVideoInfo(any)).thenThrow(ServerException());
    bloc.add(FetchVideoInfo('https://youtube.com/watch?v=test'));
    expect(bloc.state.error, isNotNull);
  });
});
```
