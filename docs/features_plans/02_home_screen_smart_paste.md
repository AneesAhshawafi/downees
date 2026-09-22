# 🏠 Feature 02: الشاشة الرئيسية واللصق الذكي

> الشاشة الرئيسية هي الواجهة الأولى للمستخدم — يجب أن تكون بسيطة، سريعة، وذكية. تشمل حقل إدخال الرابط، زر اللصق السريع، وميزة اكتشاف الروابط تلقائياً من الحافظة.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🔴 عالية |
| **التبعيات** | Feature 01 (إعداد المشروع) |
| **المدة المتوقعة** | 3-4 أيام |
| **التعقيد** | متوسط |

---

## 🎯 الأهداف

1. بناء الشاشة الرئيسية بتصميم نظيف وبسيط
2. حقل إدخال URL كبير وواضح مع زر لصق سريع
3. اللصق الذكي (Smart Paste) — كشف تلقائي للروابط من الحافظة
4. عرض التحميلات النشطة أسفل حقل الإدخال
5. شريط تنقل سفلي (Bottom Navigation) للتنقل بين الصفحات

---

## 🖼️ تصور الواجهة

```
╔══════════════════════════════════════╗
║         📥  Downees                  ║
╠══════════════════════════════════════╣
║                                      ║
║   ┌──────────────────────────────┐   ║
║   │ 🔗 الصق رابط الفيديو هنا... │   ║
║   └──────────────────────────────┘   ║
║                                      ║
║   ┌─────────┐    ┌──────────────┐    ║
║   │ 📋 لصق  │    │  ⬇️ تحميل   │    ║
║   └─────────┘    └──────────────┘    ║
║                                      ║
║  ═══ Smart Paste Banner ═══════════  ║
║  ┌────────────────────────────────┐  ║
║  │ 🔗 تم اكتشاف رابط YouTube     │  ║
║  │    [تحميل الآن] [تجاهل]       │  ║
║  └────────────────────────────────┘  ║
║                                      ║
║  ─── التحميلات النشطة ────────────   ║
║                                      ║
║  ┌────────────────────────────────┐  ║
║  │ 🎬 عنوان الفيديو              │  ║
║  │ YouTube • 720p • 35 MB        │  ║
║  │ ████████████████░░░ 78%       │  ║
║  └────────────────────────────────┘  ║
║                                      ║
╠══════════════════════════════════════╣
║  🏠 الرئيسية │ 📂 السجل │ ⚙️ إعدادات ║
╚══════════════════════════════════════╝
```

---

## 📄 الملفات المطلوبة

```
lib/features/home/
├── presentation/
│   ├── pages/
│   │   └── home_page.dart
│   ├── widgets/
│   │   ├── url_input_bar.dart          # حقل إدخال الرابط
│   │   ├── paste_button.dart           # زر اللصق السريع
│   │   ├── download_button.dart        # زر التحميل
│   │   ├── smart_paste_banner.dart     # بانر اكتشاف الرابط
│   │   ├── active_downloads_list.dart  # قائمة التحميلات النشطة
│   │   ├── active_download_card.dart   # بطاقة تحميل نشط
│   │   └── platform_icon.dart          # أيقونة المنصة
│   └── bloc/
│       ├── home_bloc.dart
│       ├── home_event.dart
│       └── home_state.dart
│
lib/shared/widgets/
├── main_shell.dart                     # Shell مع Bottom Navigation
└── bottom_nav_bar.dart                 # شريط التنقل السفلي
│
lib/core/utils/
└── clipboard_watcher.dart              # مراقب الحافظة
```

---

## 📄 التنفيذ التفصيلي

### 1. Home BLoC

#### Events
```dart
abstract class HomeEvent extends Equatable {}

class HomeStarted extends HomeEvent {}           // عند فتح الصفحة
class UrlChanged extends HomeEvent {              // عند تغيير النص
  final String url;
  UrlChanged(this.url);
}
class PasteFromClipboard extends HomeEvent {}    // عند الضغط على زر اللصق
class SubmitUrl extends HomeEvent {}              // عند الضغط على زر التحميل
class SmartPasteDetected extends HomeEvent {      // عند اكتشاف رابط في الحافظة
  final String url;
  final PlatformType platform;
  SmartPasteDetected(this.url, this.platform);
}
class SmartPasteDismissed extends HomeEvent {}    // عند تجاهل اقتراح اللصق
class AppResumed extends HomeEvent {}             // عند العودة للتطبيق
```

#### States
```dart
class HomeState extends Equatable {
  final String currentUrl;
  final PlatformType? detectedPlatform;
  final bool isValidUrl;
  final bool showSmartPaste;
  final String? smartPasteUrl;
  final PlatformType? smartPastePlatform;
  final List<DownloadTask> activeDownloads;
  
  const HomeState({
    this.currentUrl = '',
    this.detectedPlatform,
    this.isValidUrl = false,
    this.showSmartPaste = false,
    this.smartPasteUrl,
    this.smartPastePlatform,
    this.activeDownloads = const [],
  });
}
```

### 2. مراقب الحافظة (Clipboard Watcher)

```dart
class ClipboardWatcher {
  String? _lastClipboardContent;

  /// يفحص الحافظة ويعيد الرابط إذا كان جديداً ومدعوماً
  Future<({String url, PlatformType platform})?> checkClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    
    if (text == null || text == _lastClipboardContent) return null;
    _lastClipboardContent = text;
    
    final platform = UrlParser.detectPlatform(text);
    if (platform != PlatformType.unknown && UrlParser.isValidUrl(text)) {
      return (url: text, platform: platform);
    }
    return null;
  }
}
```

### 3. حقل إدخال الرابط (URL Input Bar)

```dart
class UrlInputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: state.isValidUrl 
                ? Colors.green 
                : Theme.of(context).colorScheme.outline,
              width: state.isValidUrl ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // أيقونة المنصة (تظهر عند اكتشاف منصة)
              if (state.detectedPlatform != null)
                PlatformIcon(platform: state.detectedPlatform!),
              
              // حقل الإدخال
              Expanded(
                child: TextField(
                  onChanged: (value) => context
                    .read<HomeBloc>()
                    .add(UrlChanged(value)),
                  decoration: InputDecoration(
                    hintText: context.l10n.pasteLink,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              
              // زر مسح الحقل
              if (state.currentUrl.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => context
                    .read<HomeBloc>()
                    .add(UrlChanged('')),
                ),
            ],
          ),
        );
      },
    );
  }
}
```

### 4. بانر اللصق الذكي (Smart Paste Banner)

```dart
class SmartPasteBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) => prev.showSmartPaste != curr.showSmartPaste,
      builder: (context, state) {
        return AnimatedSlide(
          offset: state.showSmartPaste 
            ? Offset.zero 
            : const Offset(0, -1),
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: state.showSmartPaste ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text('${state.smartPastePlatform?.emoji ?? '🔗'}'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.linkDetected(
                        state.smartPastePlatform?.displayName ?? ''),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context
                      .read<HomeBloc>()
                      .add(SubmitUrl()),
                    child: Text(context.l10n.downloadNow),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => context
                      .read<HomeBloc>()
                      .add(SmartPasteDismissed()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

### 5. تفعيل Smart Paste عند العودة للتطبيق

```dart
// في home_page.dart
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // فحص أولي عند فتح التطبيق
    context.read<HomeBloc>().add(AppResumed());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // فحص الحافظة عند العودة للتطبيق
      context.read<HomeBloc>().add(AppResumed());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
```

### 6. بطاقة التحميل النشط

```dart
class ActiveDownloadCard extends StatelessWidget {
  final DownloadTask task;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: task.thumbnailUrl,
            width: 60, height: 45,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${task.platform.displayName} • ${task.quality} • ${task.fileSize}'),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: task.progress,
              borderRadius: BorderRadius.circular(4),
            ),
            Text('${(task.progress * 100).toInt()}%'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            task.status == DownloadStatus.downloading
              ? Icons.pause
              : Icons.play_arrow,
          ),
          onPressed: () { /* pause/resume */ },
        ),
      ),
    );
  }
}
```

---

## 🎨 تفاصيل التصميم

### الألوان والأنماط
- حقل الإدخال: حدود مستديرة، يتحول للأخضر عند اكتشاف رابط صالح
- زر اللصق: لون ثانوي، أيقونة 📋
- زر التحميل: لون أساسي، أيقونة ⬇️، يكون disabled عند عدم وجود رابط صالح
- بانر اللصق الذكي: لون primaryContainer مع أنيميشن انزلاق
- بطاقات التحميل: Cards مع ظل خفيف

### الأنيميشن
- بانر اللصق الذكي: `AnimatedSlide` + `AnimatedOpacity` (300ms)
- زر التحميل: `AnimatedScale` عند الضغط
- شريط التقدم: `LinearProgressIndicator` مع `borderRadius`
- الانتقال لصفحة المعاينة: `Hero` animation على الصورة المصغرة

---

## ✅ معايير القبول

- [ ] الشاشة الرئيسية تعرض حقل إدخال الرابط بشكل واضح
- [ ] زر اللصق ينسخ محتوى الحافظة ويلصقه في الحقل
- [ ] يتم اكتشاف المنصة تلقائياً وعرض أيقونتها
- [ ] Smart Paste يظهر بانر عند فتح التطبيق إذا كان في الحافظة رابط مدعوم
- [ ] Smart Paste يظهر عند العودة للتطبيق (resume)
- [ ] الضغط على "تحميل" ينتقل لصفحة المعاينة
- [ ] Bottom Navigation يعمل بين الصفحات الثلاث
- [ ] التحميلات النشطة تظهر مع شريط تقدم محدث
- [ ] الواجهة تعمل بشكل صحيح في RTL و LTR

---

## 🧪 خطة الاختبار

```dart
group('HomeBloc', () {
  test('should detect platform when valid URL entered', () {
    bloc.add(UrlChanged('https://youtube.com/watch?v=xxx'));
    expect(bloc.state.detectedPlatform, PlatformType.youtube);
    expect(bloc.state.isValidUrl, true);
  });
  
  test('should show smart paste when clipboard has valid URL', () {
    bloc.add(AppResumed()); // clipboard has TikTok URL
    expect(bloc.state.showSmartPaste, true);
    expect(bloc.state.smartPastePlatform, PlatformType.tiktok);
  });
  
  test('should dismiss smart paste banner', () {
    bloc.add(SmartPasteDismissed());
    expect(bloc.state.showSmartPaste, false);
  });
});
```
