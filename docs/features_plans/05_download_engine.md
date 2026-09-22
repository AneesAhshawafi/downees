# ⬇️ Feature 05: محرك التحميل وإدارة التقدم

> المحرك الأساسي المسؤول عن تحميل الملفات من الإنترنت مع تتبع التقدم، دعم الإيقاف والاستئناف، وإدارة التحميلات المتعددة.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🔴 عالية |
| **التبعيات** | Feature 01, 04 (معاينة الفيديو) |
| **المدة المتوقعة** | 4-5 أيام |
| **التعقيد** | عالي |

---

## 🎯 الأهداف

1. تحميل الملفات باستخدام Dio مع تتبع التقدم (progress callback)
2. دعم الإيقاف المؤقت والاستئناف (Pause/Resume)
3. دعم الإلغاء (Cancel)
4. إدارة تحميلات متعددة متزامنة (Queue Management)
5. حفظ الملفات في مجلد التحميلات مع أسماء مناسبة
6. معالجة الأخطاء وإعادة المحاولة تلقائياً
7. حفظ حالة التحميل عند إغلاق التطبيق واستئنافها عند الفتح

---

## 📄 الملفات المطلوبة

```
lib/features/download/
├── data/
│   ├── models/
│   │   └── download_task_model.dart        # نموذج بيانات التحميل
│   ├── datasources/
│   │   └── download_local_datasource.dart  # حفظ/استرجاع حالة التحميل
│   └── repositories/
│       └── download_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── download_task.dart              # كيان التحميل
│   ├── repositories/
│   │   └── download_repository.dart        # Abstract
│   └── usecases/
│       ├── start_download.dart
│       ├── pause_download.dart
│       ├── resume_download.dart
│       ├── cancel_download.dart
│       └── retry_download.dart
└── presentation/
    └── bloc/
        ├── download_bloc.dart
        ├── download_event.dart
        └── download_state.dart

lib/core/services/
├── download_manager.dart                   # المحرك الرئيسي
├── download_queue.dart                     # إدارة الطابور
└── file_namer.dart                         # تسمية الملفات
```

---

## 📄 التنفيذ التفصيلي

### 1. كيان التحميل (Download Task Entity)

```dart
class DownloadTask {
  final String id;                    // معرف فريد (UUID)
  final String url;                   // رابط التحميل المباشر
  final String originalUrl;           // الرابط الأصلي
  final String title;                 // عنوان الفيديو
  final String thumbnailUrl;          // صورة مصغرة
  final PlatformType platform;        // المنصة
  final String quality;               // الجودة المختارة
  final String format;                // الصيغة (mp4, mp3)
  final int totalBytes;               // الحجم الكلي
  final int receivedBytes;            // البايتات المحملة
  final DownloadStatus status;        // الحالة
  final String savePath;              // مسار الحفظ
  final DateTime createdAt;           // وقت الإنشاء
  final DateTime? completedAt;        // وقت الاكتمال
  final String? errorMessage;         // رسالة الخطأ
  final int retryCount;               // عدد محاولات إعادة المحاولة
  
  double get progress => totalBytes > 0 ? receivedBytes / totalBytes : 0;
  String get progressPercent => '${(progress * 100).toInt()}%';
  String get receivedMB => (receivedBytes / 1024 / 1024).toStringAsFixed(1);
  String get totalMB => (totalBytes / 1024 / 1024).toStringAsFixed(1);
  String get progressText => '$receivedMB / $totalMB MB';
  
  Duration get elapsed => (completedAt ?? DateTime.now()).difference(createdAt);
  
  DownloadTask copyWith({...});
}
```

### 2. Download Manager (المحرك الرئيسي)

```dart
class DownloadManager {
  final Dio _dio;
  final DownloadQueue _queue;
  final int maxConcurrent;
  
  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, int> _pausedBytes = {};   // للاستئناف
  
  // Stream للتحديثات
  final _progressController = StreamController<DownloadTask>.broadcast();
  Stream<DownloadTask> get progressStream => _progressController.stream;
  
  DownloadManager({
    required Dio dio,
    this.maxConcurrent = 3,
  }) : _dio = dio, _queue = DownloadQueue(maxConcurrent);

  /// بدء تحميل جديد
  Future<void> startDownload(DownloadTask task) async {
    final cancelToken = CancelToken();
    _cancelTokens[task.id] = cancelToken;
    
    _emitUpdate(task.copyWith(status: DownloadStatus.downloading));
    
    try {
      await _dio.download(
        task.url,
        task.savePath,
        cancelToken: cancelToken,
        deleteOnError: false,   // للحفاظ على الجزء المحمل
        options: Options(
          headers: _pausedBytes.containsKey(task.id)
            ? {'Range': 'bytes=${_pausedBytes[task.id]}-'}
            : null,
        ),
        onReceiveProgress: (received, total) {
          final actualReceived = (_pausedBytes[task.id] ?? 0) + received;
          final actualTotal = (_pausedBytes[task.id] ?? 0) + total;
          
          _emitUpdate(task.copyWith(
            receivedBytes: actualReceived,
            totalBytes: actualTotal,
            status: DownloadStatus.downloading,
          ));
        },
      );
      
      // اكتمال التحميل
      _emitUpdate(task.copyWith(
        status: DownloadStatus.completed,
        completedAt: DateTime.now(),
      ));
      
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        // تم الإلغاء/الإيقاف من المستخدم
        return;
      }
      
      // خطأ — إعادة المحاولة تلقائياً
      if (task.retryCount < 3) {
        await Future.delayed(Duration(seconds: task.retryCount * 2));
        await startDownload(task.copyWith(
          retryCount: task.retryCount + 1,
        ));
      } else {
        _emitUpdate(task.copyWith(
          status: DownloadStatus.failed,
          errorMessage: _mapError(e),
        ));
      }
    } finally {
      _cancelTokens.remove(task.id);
    }
  }

  /// إيقاف مؤقت
  void pauseDownload(String taskId) {
    _cancelTokens[taskId]?.cancel('paused');
    // حفظ البايتات المحملة للاستئناف
  }

  /// استئناف
  Future<void> resumeDownload(DownloadTask task) async {
    _pausedBytes[task.id] = task.receivedBytes;
    await startDownload(task.copyWith(status: DownloadStatus.downloading));
  }

  /// إلغاء
  void cancelDownload(String taskId) {
    _cancelTokens[taskId]?.cancel('cancelled');
    _pausedBytes.remove(taskId);
    // حذف الملف الجزئي
  }

  /// إعادة المحاولة
  Future<void> retryDownload(DownloadTask task) async {
    _pausedBytes.remove(task.id);
    await startDownload(task.copyWith(
      status: DownloadStatus.pending,
      receivedBytes: 0,
      retryCount: 0,
      errorMessage: null,
    ));
  }

  void _emitUpdate(DownloadTask task) {
    _progressController.add(task);
  }

  String _mapError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'انتهت مهلة الاتصال',
      DioExceptionType.receiveTimeout => 'انتهت مهلة الاستقبال',
      DioExceptionType.connectionError => 'لا يوجد اتصال بالإنترنت',
      _ => 'حدث خطأ أثناء التحميل',
    };
  }
  
  void dispose() {
    _progressController.close();
  }
}
```

### 3. إدارة الطابور (Download Queue)

```dart
class DownloadQueue {
  final int maxConcurrent;
  final Queue<DownloadTask> _pending = Queue();
  final Set<String> _active = {};
  
  DownloadQueue(this.maxConcurrent);
  
  bool get canStartNext => _active.length < maxConcurrent;
  
  void enqueue(DownloadTask task) {
    _pending.add(task);
    _processNext();
  }
  
  void markActive(String taskId) {
    _active.add(taskId);
  }
  
  void markCompleted(String taskId) {
    _active.remove(taskId);
    _processNext();
  }
  
  DownloadTask? _processNext() {
    if (!canStartNext || _pending.isEmpty) return null;
    return _pending.removeFirst();
  }
}
```

### 4. تسمية الملفات

```dart
class FileNamer {
  /// إنشاء اسم ملف آمن من عنوان الفيديو
  static String generateFileName({
    required String title,
    required String quality,
    required String format,
    required PlatformType platform,
  }) {
    // تنظيف العنوان من الأحرف غير المسموحة
    final cleanTitle = title
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
    
    // اقتصار الطول
    final shortTitle = cleanTitle.length > 80 
      ? cleanTitle.substring(0, 80) 
      : cleanTitle;
    
    return '${shortTitle}_${quality}_${platform.name}.$format';
  }
  
  /// الحصول على مسار الحفظ الكامل
  static Future<String> getFullSavePath({
    required String fileName,
    String? customDir,
  }) async {
    final dir = customDir ?? await _getDefaultDownloadDir();
    final downloadsDir = Directory('$dir/Downees');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }
    
    // التحقق من عدم وجود ملف بنفس الاسم
    var filePath = '${downloadsDir.path}/$fileName';
    var counter = 1;
    while (File(filePath).existsSync()) {
      final ext = fileName.split('.').last;
      final name = fileName.substring(0, fileName.lastIndexOf('.'));
      filePath = '${downloadsDir.path}/${name}_($counter).$ext';
      counter++;
    }
    
    return filePath;
  }
}
```

### 5. Download BLoC

#### Events
```dart
abstract class DownloadEvent extends Equatable {}

class StartNewDownload extends DownloadEvent {
  final VideoInfo videoInfo;
  final VideoQuality quality;
  final bool isAudioOnly;
  StartNewDownload(this.videoInfo, this.quality, this.isAudioOnly);
}

class PauseDownload extends DownloadEvent {
  final String taskId;
  PauseDownload(this.taskId);
}

class ResumeDownload extends DownloadEvent {
  final String taskId;
  ResumeDownload(this.taskId);
}

class CancelDownload extends DownloadEvent {
  final String taskId;
  CancelDownload(this.taskId);
}

class RetryDownload extends DownloadEvent {
  final String taskId;
  RetryDownload(this.taskId);
}

class DownloadProgressUpdated extends DownloadEvent {
  final DownloadTask task;
  DownloadProgressUpdated(this.task);
}
```

#### State
```dart
class DownloadState extends Equatable {
  final Map<String, DownloadTask> tasks;  // id -> task
  
  List<DownloadTask> get activeTasks => tasks.values
    .where((t) => t.status == DownloadStatus.downloading || 
                  t.status == DownloadStatus.paused)
    .toList();
    
  List<DownloadTask> get completedTasks => tasks.values
    .where((t) => t.status == DownloadStatus.completed)
    .toList();
    
  List<DownloadTask> get failedTasks => tasks.values
    .where((t) => t.status == DownloadStatus.failed)
    .toList();
}
```

---

## ⚙️ إعدادات التحميل

| الإعداد | القيمة الافتراضية | الوصف |
|---|---|---|
| `maxConcurrentDownloads` | 3 | عدد التحميلات المتزامنة |
| `maxRetries` | 3 | عدد محاولات إعادة المحاولة |
| `connectionTimeout` | 30 ثانية | مهلة الاتصال |
| `receiveTimeout` | 0 (بلا حد) | مهلة الاستقبال |
| `defaultDownloadDir` | `Downloads/Downees` | مجلد التحميل الافتراضي |
| `autoRetryDelay` | تصاعدي (2s, 4s, 6s) | تأخير إعادة المحاولة |

---

## 📱 الصلاحيات المطلوبة

```xml
<!-- Android -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
  android:maxSdkVersion="28" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />

<!-- للوصول لمجلد Downloads في Android 10+ -->
<application
  android:requestLegacyExternalStorage="true">
```

---

## ✅ معايير القبول

- [ ] التحميل يبدأ بنجاح ويظهر شريط تقدم محدث
- [ ] يمكن إيقاف التحميل مؤقتاً واستئنافه من نفس النقطة
- [ ] يمكن إلغاء التحميل وحذف الملف الجزئي
- [ ] يمكن إعادة المحاولة عند الفشل
- [ ] إعادة المحاولة التلقائية تعمل (حتى 3 مرات)
- [ ] يمكن تحميل 3 ملفات في نفس الوقت
- [ ] يتم إضافة التحميلات الزائدة في الطابور
- [ ] الملفات تُحفظ في `Downloads/Downees` بأسماء واضحة
- [ ] لا يتم الكتابة فوق ملفات موجودة (يُضاف رقم)
- [ ] الأخطاء تُعرض برسائل واضحة
- [ ] حالة التحميل محفوظة عند إغلاق التطبيق

---

## 🧪 خطة الاختبار

```dart
group('DownloadManager', () {
  test('should start download and emit progress', () async {
    await manager.startDownload(testTask);
    expect(
      manager.progressStream,
      emitsInOrder([
        isA<DownloadTask>().having((t) => t.status, '', DownloadStatus.downloading),
        isA<DownloadTask>().having((t) => t.progress, '', greaterThan(0)),
        isA<DownloadTask>().having((t) => t.status, '', DownloadStatus.completed),
      ]),
    );
  });
  
  test('should pause and resume download', () async {
    manager.pauseDownload(testTask.id);
    // verify bytes saved
    await manager.resumeDownload(testTask);
    // verify range header sent
  });
  
  test('should auto-retry on failure', () async {
    // simulate network error
    // verify retry up to 3 times
  });
  
  test('should respect max concurrent limit', () {
    // start 5 downloads, verify only 3 active
  });
});

group('FileNamer', () {
  test('should sanitize file name', () {
    expect(
      FileNamer.generateFileName(
        title: 'Video: Test/File?',
        quality: '720p',
        format: 'mp4',
        platform: PlatformType.youtube,
      ),
      'Video Test File_720p_youtube.mp4',
    );
  });
  
  test('should handle duplicate file names', () async {
    // create a file, verify new name has (1) suffix
  });
});
```
