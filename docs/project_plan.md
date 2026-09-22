# 📥 Downees — خطة وتحليل تطبيق تحميل الفيديوهات

> تطبيق Flutter لتحميل الفيديوهات من منصات التواصل الاجتماعي المختلفة بتجربة مستخدم سلسة وبسيطة.

---

## 📌 نظرة عامة

| العنصر | التفاصيل |
|---|---|
| **اسم التطبيق** | Downees |
| **التقنية** | Flutter (Dart) |
| **المنصة المستهدفة** | Android (أولاً)، ثم iOS لاحقاً |
| **الهدف** | تمكين المستخدم من تحميل الفيديوهات من منصات التواصل الاجتماعي بسهولة |

---

## 🎯 المنصات المدعومة

| المنصة | الأولوية | ملاحظات |
|---|---|---|
| YouTube | 🔴 عالية | أكثر المنصات طلباً |
| Instagram (Reels/Stories/Posts) | 🔴 عالية | يشمل Reels و Stories و Posts |
| TikTok | 🔴 عالية | فيديوهات بدون علامة مائية |
| Twitter/X | 🟡 متوسطة | فيديوهات التغريدات |
| Facebook | 🟡 متوسطة | فيديوهات عامة |
| Snapchat Spotlight | 🟢 منخفضة | إضافة مستقبلية |

---

## 🏗️ هيكلة المشروع المقترحة

```
lib/
├── main.dart
├── app.dart                          # إعداد التطبيق (Theme, Routes, Localization)
│
├── core/                             # الأدوات والخدمات المشتركة
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── api_constants.dart
│   ├── enums/
│   │   ├── platform_type.dart        # youtube, instagram, tiktok...
│   │   └── download_status.dart      # pending, downloading, completed, failed
│   ├── utils/
│   │   ├── url_parser.dart           # تحليل الروابط واستخراج المنصة
│   │   ├── file_utils.dart           # إدارة الملفات والمسارات
│   │   ├── permission_handler.dart   # صلاحيات التخزين
│   │   └── clipboard_watcher.dart    # مراقبة الحافظة
│   ├── network/
│   │   ├── api_client.dart           # Dio client
│   │   ├── api_interceptors.dart
│   │   └── api_exceptions.dart
│   └── di/
│       └── injection.dart            # Dependency Injection (get_it)
│
├── features/                         # الميزات (Feature-First Architecture)
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── home_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── url_input_bar.dart
│   │   │   │   ├── platform_chip.dart
│   │   │   │   └── quick_paste_button.dart
│   │   │   └── bloc/
│   │   │       ├── home_bloc.dart
│   │   │       ├── home_event.dart
│   │   │       └── home_state.dart
│   │   └── domain/
│   │       └── usecases/
│   │           └── parse_url_usecase.dart
│   │
│   ├── download/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── video_info_model.dart
│   │   │   │   └── download_task_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── download_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── youtube_datasource.dart
│   │   │       ├── instagram_datasource.dart
│   │   │       ├── tiktok_datasource.dart
│   │   │       └── twitter_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── video_info.dart
│   │   │   │   └── download_task.dart
│   │   │   ├── repositories/
│   │   │   │   └── download_repository.dart
│   │   │   └── usecases/
│   │   │       ├── fetch_video_info.dart
│   │   │       ├── start_download.dart
│   │   │       └── cancel_download.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── download_preview_page.dart
│   │       ├── widgets/
│   │       │   ├── video_preview_card.dart
│   │       │   ├── quality_selector.dart
│   │       │   ├── download_progress_bar.dart
│   │       │   └── format_toggle.dart
│   │       └── bloc/
│   │           ├── download_bloc.dart
│   │           ├── download_event.dart
│   │           └── download_state.dart
│   │
│   ├── history/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── history_item_model.dart
│   │   │   └── repositories/
│   │   │       └── history_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── history_item.dart
│   │   │   ├── repositories/
│   │   │   │   └── history_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_history.dart
│   │   │       ├── delete_history_item.dart
│   │   │       └── clear_history.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── history_page.dart
│   │       ├── widgets/
│   │       │   ├── history_list_item.dart
│   │       │   └── history_filter_bar.dart
│   │       └── bloc/
│   │           ├── history_bloc.dart
│   │           ├── history_event.dart
│   │           └── history_state.dart
│   │
│   └── settings/
│       └── presentation/
│           ├── pages/
│           │   └── settings_page.dart
│           └── widgets/
│               ├── theme_switcher.dart
│               ├── download_path_picker.dart
│               └── language_selector.dart
│
├── shared/                           # ويدجتات وعناصر مشتركة
│   ├── widgets/
│   │   ├── app_snackbar.dart
│   │   ├── loading_overlay.dart
│   │   ├── error_widget.dart
│   │   └── animated_download_icon.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── dark_theme.dart
│       └── light_theme.dart
│
└── l10n/                             # ملفات الترجمة
    ├── app_ar.arb
    └── app_en.arb
```

---

## 📦 الحزم والمكتبات المقترحة

### أساسية

| الحزمة | الغرض |
|---|---|
| `flutter_bloc` | إدارة الحالة (State Management) |
| `dio` | عمليات الشبكة والتحميل |
| `get_it` + `injectable` | Dependency Injection |
| `go_router` | التنقل بين الصفحات |
| `hive` أو `isar` | قاعدة بيانات محلية خفيفة للسجل |
| `path_provider` | مسارات التخزين |
| `permission_handler` | إدارة الصلاحيات |

### تحسين التجربة

| الحزمة | الغرض |
|---|---|
| `flutter_local_notifications` | إشعارات اكتمال التحميل |
| `share_plus` | مشاركة الفيديو بعد التحميل |
| `receive_sharing_intent` | استقبال الروابط من تطبيقات أخرى (Share Intent) |
| `clipboard` | مراقبة الحافظة للصق التلقائي |
| `lottie` | أنيميشن جذاب (حالة التحميل، النجاح، الخطأ) |
| `cached_network_image` | عرض صور مصغرة للفيديوهات |
| `flutter_animate` | تحريكات سلسة للعناصر |
| `connectivity_plus` | مراقبة حالة الاتصال |

---

## ⚙️ آلية العمل (Data Flow)

```
┌─────────────────────────────────────────────────────────────────┐
│                        المستخدم                                  │
│  1. لصق رابط / مشاركة من تطبيق آخر / كشف تلقائي من الحافظة     │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    URL Parser                                    │
│  ✓ التحقق من صحة الرابط                                         │
│  ✓ تحديد المنصة (YouTube, Instagram, TikTok...)                 │
│  ✓ استخراج معرّف الفيديو                                        │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                Platform-Specific DataSource                      │
│  ✓ جلب معلومات الفيديو (عنوان، صورة مصغرة، مدة)                │
│  ✓ استخراج روابط التحميل المباشرة                                │
│  ✓ عرض الجودات المتاحة (360p, 720p, 1080p, 4K)                 │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Download Preview Page                            │
│  ✓ عرض معاينة الفيديو                                           │
│  ✓ اختيار الجودة                                                 │
│  ✓ اختيار الصيغة (MP4, MP3 صوت فقط)                             │
│  ✓ زر بدء التحميل                                               │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Download Manager                                │
│  ✓ تحميل في الخلفية مع شريط تقدم                                │
│  ✓ إشعار عند الاكتمال                                           │
│  ✓ إمكانية الإيقاف والاستئناف                                    │
│  ✓ حفظ في سجل التحميلات                                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🌟 اقتراحات لتحسين تجربة المستخدم (UX)

### 1. 📋 اللصق الذكي (Smart Paste)

> عند فتح التطبيق، يفحص الحافظة تلقائياً. إذا وجد رابط فيديو مدعوم، يعرض اقتراح لصق سريع بأنيميشن لطيف.

```
┌────────────────────────────────────────┐
│  🔗 تم اكتشاف رابط TikTok             │
│  هل تريد تحميل هذا الفيديو؟            │
│                                        │
│  [تحميل الآن]       [تجاهل]            │
└────────────────────────────────────────┘
```

**التنفيذ:**
- استخدام `clipboard` package لمراقبة الحافظة عند `AppLifecycleState.resumed`
- عرض `SnackBar` أو `BottomSheet` مخصص عند اكتشاف رابط

---

### 2. 📤 Share Intent — استقبال الروابط مباشرة

> يمكن للمستخدم مشاركة الرابط من أي تطبيق (YouTube, Instagram...) إلى Downees مباشرة بدون فتح التطبيق أولاً.

**التنفيذ:**
- استخدام `receive_sharing_intent` package
- تسجيل التطبيق كـ Intent handler للروابط النصية في `AndroidManifest.xml`
- عند استلام الرابط → فتح صفحة المعاينة مباشرة

---

### 3. 🎛️ اختيار الجودة الذكي

> بدلاً من قائمة طويلة، عرض أزرار واضحة مع حجم الملف المتوقع لكل جودة.

```
┌──────────────────────────────────────────┐
│  📹 اختر الجودة                          │
│                                          │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐    │
│  │  360p   │ │  720p   │ │  1080p  │    │
│  │  12 MB  │ │  35 MB  │ │  85 MB  │    │
│  │         │ │  ⭐ أفضل │ │         │    │
│  └─────────┘ └─────────┘ └─────────┘    │
│                                          │
│  🎵 صوت فقط (MP3) — 4 MB                │
└──────────────────────────────────────────┘
```

---

### 4. 🔔 تحميل في الخلفية مع إشعارات

> عند بدء التحميل، يمكن للمستخدم إغلاق التطبيق والعودة لاحقاً.

- إشعار مستمر يُظهر شريط التقدم
- إشعار عند اكتمال التحميل مع خيارات:
  - **فتح الفيديو** 🎬
  - **مشاركة** 📤
  - **حذف** 🗑️

---

### 5. 📊 سجل تحميلات ذكي

> صفحة تعرض كل التحميلات السابقة مع إمكانية البحث والتصفية.

- تصفية حسب المنصة (أيقونات: YouTube, TikTok...)
- تصفية حسب التاريخ
- عرض الصورة المصغرة + عنوان الفيديو + الحجم + التاريخ
- خيارات: إعادة تحميل / مشاركة / حذف
- سحب للحذف (Swipe to delete)

---

### 6. 🌙 الوضع الداكن / الفاتح

> دعم الوضع الداكن تلقائياً حسب إعداد النظام، مع إمكانية التبديل يدوياً.

---

### 7. 🌐 دعم اللغات (العربية والإنجليزية)

> واجهة ثنائية اللغة مع دعم RTL كامل للعربية.

---

### 8. 📱 واجهة بسيطة بخطوة واحدة

> الشاشة الرئيسية تحتوي فقط على:
> 1. حقل لصق الرابط (كبير وواضح)
> 2. زر لصق سريع 📋
> 3. زر تحميل ⬇️

**الفلسفة:** أقل نقرات ممكنة = أفضل تجربة.

---

### 9. ⚡ اقتراحات إضافية متقدمة

| الاقتراح | الوصف |
|---|---|
| **تحميل دفعي (Batch)** | تحميل عدة روابط مرة واحدة |
| **جدولة التحميل** | تأجيل التحميل لوقت محدد (مثلاً عند اتصال WiFi) |
| **تحويل لـ MP3** | استخراج الصوت فقط من الفيديو |
| **مشغّل مدمج** | تشغيل الفيديو داخل التطبيق قبل التحميل |
| **مفضلات** | حفظ روابط لتحميلها لاحقاً |
| **Widget على الشاشة الرئيسية** | ويدجت لصق سريع بدون فتح التطبيق |

---

## 🔧 الجوانب التقنية المهمة

### استخراج روابط التحميل

هناك طريقتان رئيسيتان:

#### الطريقة 1: Backend API (مُوصى بها ✅)

```
التطبيق  →  Backend Server (Node.js / Python)  →  yt-dlp / instaloader  →  رابط مباشر
```

**المميزات:**
- مرونة عالية — سهل التحديث عند تغيير المنصات لـ APIs الخاصة بها
- أمان — المفاتيح والمنطق في السيرفر
- التطبيق يبقى خفيف

**الأدوات المقترحة للسيرفر:**
- `yt-dlp` (Python) — يدعم مئات المنصات
- `Node.js` + `Express` كـ REST API
- أو `FastAPI` (Python) كبديل سريع

#### الطريقة 2: Web Scraping مباشر من التطبيق

```
التطبيق  →  طلب HTTP مباشر للمنصة  →  تحليل HTML/JSON  →  رابط مباشر
```

**المميزات:**
- لا حاجة لسيرفر خارجي

**العيوب:**
- يتوقف عند تغيير المنصات لـ HTML/API
- صعوبة الصيانة
- بعض المنصات تحجب الطلبات

> **📌 التوصية:** استخدام الطريقة الأولى (Backend) لاستقرار أفضل مع إمكانية التحديث بدون تحديث التطبيق.

---

### إدارة التحميل

```dart
// مثال مبسط لهيكل Download Manager
class DownloadManager {
  final Dio _dio;
  final Map<String, CancelToken> _activeDownloads = {};

  Future<void> startDownload({
    required String url,
    required String savePath,
    required Function(int received, int total) onProgress,
    required Function() onComplete,
    required Function(String error) onError,
  }) async {
    final cancelToken = CancelToken();
    _activeDownloads[url] = cancelToken;

    try {
      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          onProgress(received, total);
        },
      );
      onComplete();
    } catch (e) {
      onError(e.toString());
    } finally {
      _activeDownloads.remove(url);
    }
  }

  void cancelDownload(String url) {
    _activeDownloads[url]?.cancel();
  }
}
```

---

### الصلاحيات المطلوبة (Android)

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

---

## 📅 مراحل التنفيذ

### المرحلة 1 — الأساس (أسبوعان)

- [x] إنشاء المشروع
- [ ] إعداد هيكلة المجلدات
- [ ] إعداد Dependency Injection و الثيمات
- [ ] بناء الشاشة الرئيسية (حقل اللصق + زر التحميل)
- [ ] بناء URL Parser لتحديد المنصة
- [ ] إعداد صلاحيات Android

### المرحلة 2 — التحميل (أسبوعان)

- [ ] إنشاء Backend API (أو ربط مع خدمة جاهزة)
- [ ] بناء Download Manager مع Dio
- [ ] صفحة معاينة الفيديو (صورة مصغرة + معلومات + اختيار الجودة)
- [ ] شريط تقدم التحميل
- [ ] حفظ الملفات في مجلد التحميلات

### المرحلة 3 — التجربة (أسبوع)

- [ ] اللصق الذكي (Smart Paste)
- [ ] Share Intent (استقبال من تطبيقات أخرى)
- [ ] إشعارات التحميل
- [ ] سجل التحميلات (History)

### المرحلة 4 — التحسين (أسبوع)

- [ ] الوضع الداكن / الفاتح
- [ ] دعم العربية والإنجليزية
- [ ] أنيميشن (Lottie)
- [ ] اختبارات وحدة (Unit Tests)
- [ ] اختبار على أجهزة مختلفة

### المرحلة 5 — ميزات متقدمة (مستقبلاً)

- [ ] تحميل دفعي
- [ ] تحويل لـ MP3
- [ ] مشغّل فيديو مدمج
- [ ] Widget للشاشة الرئيسية
- [ ] دعم منصات إضافية

---

## ⚠️ ملاحظات قانونية

> [!CAUTION]
> - تأكد من الالتزام بشروط استخدام كل منصة
> - بعض المنصات تمنع تحميل المحتوى في شروط خدمتها
> - أضف إخلاء مسؤولية في التطبيق ينص على أن المستخدم مسؤول عن استخدامه
> - لا تستخدم التطبيق لتحميل محتوى محمي بحقوق الملكية

---

## 📐 تصور مبدئي للواجهات

### الشاشة الرئيسية

```
╔══════════════════════════════════════╗
║         📥  Downees                  ║
╠══════════════════════════════════════╣
║                                      ║
║   ┌──────────────────────────────┐   ║
║   │ 🔗 الصق رابط الفيديو هنا...  │   ║
║   └──────────────────────────────┘   ║
║                                      ║
║   ┌─────────┐    ┌──────────────┐    ║
║   │ 📋 لصق  │    │ ⬇️  تحميل   │    ║
║   └─────────┘    └──────────────┘    ║
║                                      ║
║  ─ ─ ─ ─ ─ آخر التحميلات ─ ─ ─ ─   ║
║                                      ║
║  ┌────────────────────────────────┐  ║
║  │ 🎬 عنوان الفيديو 1           │  ║
║  │ YouTube • 720p • 35 MB        │  ║
║  │ ████████████████░░░ 78%       │  ║
║  └────────────────────────────────┘  ║
║                                      ║
║  ┌────────────────────────────────┐  ║
║  │ 🎬 عنوان الفيديو 2           │  ║
║  │ TikTok • 1080p • 12 MB       │  ║
║  │ ✅ مكتمل                      │  ║
║  └────────────────────────────────┘  ║
║                                      ║
╠══════════════════════════════════════╣
║   🏠 الرئيسية  │ 📂 السجل │ ⚙️ إعدادات  ║
╚══════════════════════════════════════╝
```

---

> 📝 **آخر تحديث:** سبتمبر 2026

