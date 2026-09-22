# 📤 Feature 07: استقبال الروابط من التطبيقات (Share Intent)

> تمكين المستخدم من مشاركة رابط الفيديو مباشرة من أي تطبيق (YouTube, Instagram, TikTok...) إلى Downees بدون فتح التطبيق أولاً.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🔴 عالية |
| **التبعيات** | Feature 01, 03 (URL Parser), 04 (معاينة) |
| **المدة المتوقعة** | 2-3 أيام |
| **التعقيد** | متوسط |

---

## 🎯 الأهداف

1. تسجيل التطبيق كـ Intent Handler لاستقبال النصوص والروابط
2. عند مشاركة رابط من تطبيق آخر، يفتح Downees مباشرة على صفحة المعاينة
3. دعم الاستقبال عندما يكون التطبيق مغلقاً أو مفتوحاً
4. التحقق من صحة الرابط المستقبل قبل المعالجة

---

## 📱 سيناريوهات الاستخدام

### السيناريو 1: التطبيق مغلق
```
1. المستخدم في YouTube → يضغط "مشاركة" → يختار Downees
2. Downees يفتح → ينتقل مباشرة لصفحة معاينة الفيديو
3. يعرض معلومات الفيديو + اختيار الجودة
```

### السيناريو 2: التطبيق مفتوح
```
1. المستخدم في Instagram → يضغط "مشاركة" → يختار Downees
2. Downees يظهر في المقدمة → ينتقل لصفحة المعاينة
3. التحميلات السابقة لا تتأثر
```

### السيناريو 3: رابط غير مدعوم
```
1. المستخدم يشارك رابط من تطبيق غير مدعوم
2. Downees يفتح → يعرض رسالة "المنصة غير مدعومة"
3. يقترح المنصات المدعومة
```

---

## 📄 الملفات المطلوبة

```
lib/core/services/
└── share_intent_service.dart           # إدارة الروابط الواردة

lib/core/utils/
└── intent_handler.dart                 # معالجة الروابط الواردة

android/app/src/main/
└── AndroidManifest.xml                 # تعديل — إضافة intent-filter
```

---

## 📄 التنفيذ التفصيلي

### 1. AndroidManifest.xml

```xml
<activity
  android:name=".MainActivity"
  android:launchMode="singleTask"
  android:exported="true">
  
  <!-- Intent Filters الحالية -->
  <intent-filter>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LAUNCHER" />
  </intent-filter>
  
  <!-- ✅ استقبال النصوص المشاركة -->
  <intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="text/plain" />
  </intent-filter>
  
  <!-- ✅ استقبال الروابط مباشرة (Deep Links) -->
  <intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <!-- يمكن إضافة روابط مخصصة لاحقاً -->
    <data android:scheme="downees" />
  </intent-filter>
</activity>
```

### 2. خدمة استقبال المشاركة

```dart
class ShareIntentService {
  final ReceiveSharingIntent _sharingIntent;
  StreamSubscription? _subscription;
  
  /// الاستماع للروابط الواردة (التطبيق مفتوح)
  void startListening({
    required Function(String url) onUrlReceived,
    required Function(String error) onError,
  }) {
    // عند استقبال رابط والتطبيق مفتوح
    _subscription = ReceiveSharingIntent.instance
      .getMediaStream()
      .listen((List<SharedMediaFile> files) {
        _handleSharedMedia(files, onUrlReceived, onError);
      });
  }
  
  /// جلب الرابط الابتدائي (التطبيق كان مغلقاً)
  Future<String?> getInitialUrl() async {
    final files = await ReceiveSharingIntent.instance.getInitialMedia();
    if (files.isEmpty) return null;
    
    final url = _extractUrl(files.first);
    if (url != null && UrlParser.isValidUrl(url)) {
      return url;
    }
    return null;
  }
  
  void _handleSharedMedia(
    List<SharedMediaFile> files,
    Function(String) onUrlReceived,
    Function(String) onError,
  ) {
    if (files.isEmpty) return;
    
    final url = _extractUrl(files.first);
    if (url == null) {
      onError('لم يتم العثور على رابط');
      return;
    }
    
    if (!UrlParser.isValidUrl(url)) {
      onError('المنصة غير مدعومة');
      return;
    }
    
    onUrlReceived(url);
  }
  
  /// استخراج URL من النص المشارك
  String? _extractUrl(SharedMediaFile file) {
    final text = file.path; // أو file.message
    if (text == null) return null;
    
    // البحث عن رابط في النص
    final urlRegex = RegExp(
      r'https?://[\w\-._~:/?#\[\]@!$&\'()*+,;=%]+',
      caseSensitive: false,
    );
    final match = urlRegex.firstMatch(text);
    return match?.group(0);
  }
  
  void dispose() {
    _subscription?.cancel();
  }
}
```

### 3. التكامل مع التطبيق

```dart
// في app.dart أو main.dart
class _DowneesAppState extends State<DowneesApp> {
  final _shareIntentService = getIt<ShareIntentService>();
  
  @override
  void initState() {
    super.initState();
    _handleInitialShare();
    _listenForShares();
  }
  
  Future<void> _handleInitialShare() async {
    final url = await _shareIntentService.getInitialUrl();
    if (url != null) {
      // الانتقال لصفحة المعاينة مباشرة
      appRouter.push('/preview', extra: url);
    }
  }
  
  void _listenForShares() {
    _shareIntentService.startListening(
      onUrlReceived: (url) {
        appRouter.push('/preview', extra: url);
      },
      onError: (error) {
        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
    );
  }
}
```

---

## 🎨 تجربة المستخدم

### ظهور Downees في قائمة المشاركة
- أيقونة التطبيق واضحة
- اسم التطبيق "Downees" يظهر
- الأيقونة مميزة (⬇️) ليسهل إيجادها

### عند استقبال رابط مدعوم
- انتقال مباشر لصفحة المعاينة
- أنيميشن سلس
- لا يحتاج أي تفاعل إضافي

### عند استقبال رابط غير مدعوم
- SnackBar مع رسالة واضحة
- يبقى في الشاشة الرئيسية
- الرابط يُلصق في حقل الإدخال للمراجعة

---

## ✅ معايير القبول

- [ ] Downees يظهر في قائمة المشاركة لجميع التطبيقات
- [ ] عند مشاركة رابط YouTube → ينتقل لصفحة المعاينة
- [ ] عند مشاركة رابط Instagram → ينتقل لصفحة المعاينة
- [ ] عند مشاركة رابط TikTok → ينتقل لصفحة المعاينة
- [ ] عند مشاركة رابط غير مدعوم → يعرض رسالة خطأ
- [ ] يعمل عندما يكون التطبيق مغلقاً (cold start)
- [ ] يعمل عندما يكون التطبيق مفتوحاً (warm)
- [ ] لا يؤثر على التحميلات النشطة عند استقبال رابط جديد
- [ ] يستخرج URL من نص يحتوي نص إضافي (مثل: "شاهد هذا الفيديو https://...")

---

## 🧪 خطة الاختبار

```dart
group('ShareIntentService', () {
  test('should extract URL from plain text', () {
    final url = service.extractUrl('Check this video https://youtube.com/watch?v=xxx wow');
    expect(url, 'https://youtube.com/watch?v=xxx');
  });
  
  test('should return null for text without URL', () {
    final url = service.extractUrl('Hello world no link here');
    expect(url, isNull);
  });
  
  test('should handle initial share when app is cold started', () async {
    when(sharingIntent.getInitialMedia()).thenReturn([
      SharedMediaFile(path: 'https://youtube.com/watch?v=xxx'),
    ]);
    
    final url = await service.getInitialUrl();
    expect(url, isNotNull);
  });
});
```
