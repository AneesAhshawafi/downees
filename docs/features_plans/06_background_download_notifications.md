# 🔔 Feature 06: التحميل في الخلفية والإشعارات

> تمكين المستخدم من إغلاق التطبيق أثناء التحميل مع عرض إشعار مستمر يُظهر التقدم، وإشعار عند اكتمال التحميل مع خيارات سريعة.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🔴 عالية |
| **التبعيات** | Feature 05 (محرك التحميل) |
| **المدة المتوقعة** | 3-4 أيام |
| **التعقيد** | عالي |

---

## 🎯 الأهداف

1. إعداد Foreground Service لـ Android للتحميل في الخلفية
2. إشعار مستمر أثناء التحميل يُظهر شريط التقدم
3. إشعار عند اكتمال التحميل مع أزرار (فتح، مشاركة، حذف)
4. إشعار عند فشل التحميل مع زر إعادة المحاولة
5. تحديث الإشعار بشكل ذكي (ليس كل بايت — كل 2-5%)

---

## 📄 الملفات المطلوبة

```
lib/core/services/
├── foreground_service.dart          # إدارة Foreground Service
├── notification_service.dart        # إدارة الإشعارات
└── notification_channels.dart       # تعريف قنوات الإشعارات

android/app/src/main/
├── AndroidManifest.xml              # تعديل — إضافة الخدمة والصلاحيات
└── kotlin/.../
    └── DownloadService.kt           # Native Foreground Service
```

---

## 📄 التنفيذ التفصيلي

### 1. قنوات الإشعارات

```dart
class NotificationChannels {
  static const downloadProgress = 'download_progress';
  static const downloadComplete = 'download_complete';
  static const downloadFailed = 'download_failed';
  
  static Future<void> createChannels() async {
    final plugin = FlutterLocalNotificationsPlugin();
    
    // قناة التقدم — بدون صوت (صامتة)
    await plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(AndroidNotificationChannel(
        downloadProgress,
        'Download Progress',
        description: 'Shows download progress',
        importance: Importance.low,      // بدون صوت أو اهتزاز
        playSound: false,
        enableVibration: false,
        showBadge: false,
      ));
    
    // قناة الاكتمال — بصوت
    await plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(AndroidNotificationChannel(
        downloadComplete,
        'Download Complete',
        description: 'Notifies when download is complete',
        importance: Importance.high,
      ));
    
    // قناة الفشل
    await plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(AndroidNotificationChannel(
        downloadFailed,
        'Download Failed',
        description: 'Notifies when download fails',
        importance: Importance.high,
      ));
  }
}
```

### 2. خدمة الإشعارات

```dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  int _lastPercent = -1;  // لمنع التحديث المتكرر
  
  NotificationService(this._plugin);

  /// إشعار تقدم التحميل (يتحدث كل 2%)
  Future<void> showProgressNotification({
    required int id,
    required String title,
    required int progress,     // 0-100
    required String subtitle,  // "35 MB / 85 MB"
  }) async {
    // تحديث فقط عند تغيير 2% أو أكثر
    if ((progress - _lastPercent).abs() < 2 && progress != 100) return;
    _lastPercent = progress;
    
    await _plugin.show(
      id,
      '⬇️ $title',
      subtitle,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.downloadProgress,
          'Download Progress',
          channelShowBadge: false,
          ongoing: true,          // لا يمكن إزالته بالسحب
          autoCancel: false,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          playSound: false,
          enableVibration: false,
          priority: Priority.low,
          category: AndroidNotificationCategory.progress,
          // أزرار الإجراءات
          actions: [
            AndroidNotificationAction('pause', '⏸️ إيقاف'),
            AndroidNotificationAction('cancel', '❌ إلغاء'),
          ],
        ),
      ),
    );
  }

  /// إشعار اكتمال التحميل
  Future<void> showCompleteNotification({
    required int id,
    required String title,
    required String filePath,
  }) async {
    _lastPercent = -1;
    
    await _plugin.show(
      id,
      '✅ اكتمل التحميل',
      title,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.downloadComplete,
          'Download Complete',
          autoCancel: true,
          priority: Priority.high,
          category: AndroidNotificationCategory.status,
          actions: [
            AndroidNotificationAction('open', '🎬 فتح'),
            AndroidNotificationAction('share', '📤 مشاركة'),
            AndroidNotificationAction('delete', '🗑️ حذف'),
          ],
        ),
      ),
      payload: filePath,  // لفتح الملف عند الضغط
    );
  }

  /// إشعار فشل التحميل
  Future<void> showFailedNotification({
    required int id,
    required String title,
    required String error,
  }) async {
    _lastPercent = -1;
    
    await _plugin.show(
      id,
      '❌ فشل التحميل',
      '$title\n$error',
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.downloadFailed,
          'Download Failed',
          autoCancel: true,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction('retry', '🔄 إعادة المحاولة'),
          ],
        ),
      ),
    );
  }

  /// إزالة إشعار
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
```

### 3. Foreground Service

```dart
class ForegroundService {
  /// تشغيل الخدمة الأمامية
  static Future<void> start() async {
    // استخدام flutter_foreground_task أو workmanager
    await FlutterForegroundTask.startService(
      notificationTitle: 'Downees',
      notificationText: 'جاري التحميل...',
      callback: downloadCallback,
    );
  }
  
  /// إيقاف الخدمة
  static Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}
```

### 4. AndroidManifest.xml

```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<application>
  <service
    android:name="com.downees.DownloadService"
    android:foregroundServiceType="dataSync"
    android:exported="false" />
</application>
```

### 5. ربط المحرك بالإشعارات

```dart
// في download_manager.dart — تعديل
class DownloadManager {
  final NotificationService _notificationService;
  
  void _emitUpdate(DownloadTask task) {
    _progressController.add(task);
    
    // تحديث الإشعار حسب الحالة
    switch (task.status) {
      case DownloadStatus.downloading:
        _notificationService.showProgressNotification(
          id: task.id.hashCode,
          title: task.title,
          progress: (task.progress * 100).toInt(),
          subtitle: task.progressText,
        );
        break;
      case DownloadStatus.completed:
        _notificationService.showCompleteNotification(
          id: task.id.hashCode,
          title: task.title,
          filePath: task.savePath,
        );
        break;
      case DownloadStatus.failed:
        _notificationService.showFailedNotification(
          id: task.id.hashCode,
          title: task.title,
          error: task.errorMessage ?? '',
        );
        break;
      default:
        break;
    }
  }
}
```

---

## 📱 أنواع الإشعارات

### إشعار التقدم (أثناء التحميل)
```
┌─────────────────────────────────────┐
│ ⬇️ عنوان الفيديو                    │
│ 35 MB / 85 MB                       │
│ ████████████████░░░░░░░░ 41%        │
│                   [⏸️ إيقاف] [❌ إلغاء] │
└─────────────────────────────────────┘
```

### إشعار الاكتمال
```
┌─────────────────────────────────────┐
│ ✅ اكتمل التحميل                    │
│ عنوان الفيديو                       │
│     [🎬 فتح] [📤 مشاركة] [🗑️ حذف]    │
└─────────────────────────────────────┘
```

### إشعار الفشل
```
┌─────────────────────────────────────┐
│ ❌ فشل التحميل                      │
│ عنوان الفيديو                       │
│ لا يوجد اتصال بالإنترنت             │
│          [🔄 إعادة المحاولة]          │
└─────────────────────────────────────┘
```

---

## ✅ معايير القبول

- [ ] التحميل يستمر عند إغلاق التطبيق (Foreground Service)
- [ ] إشعار مستمر يُظهر شريط التقدم أثناء التحميل
- [ ] الإشعار يتحدث كل 2% فقط (ليس كل بايت)
- [ ] أزرار إيقاف/إلغاء في إشعار التقدم تعمل
- [ ] إشعار اكتمال يظهر مع أزرار (فتح، مشاركة، حذف)
- [ ] الضغط على "فتح" يفتح الفيديو في المشغل
- [ ] الضغط على "مشاركة" يفتح قائمة المشاركة
- [ ] إشعار الفشل يظهر مع زر إعادة المحاولة
- [ ] إشعار التقدم صامت (بدون صوت أو اهتزاز)
- [ ] إشعار الاكتمال مع صوت
- [ ] الإشعارات تظهر بشكل صحيح في Android 13+ (POST_NOTIFICATIONS)

---

## 🧪 خطة الاختبار

```dart
group('NotificationService', () {
  test('should show progress notification', () async {
    await service.showProgressNotification(
      id: 1, title: 'Test', progress: 50, subtitle: '25/50 MB',
    );
    verify(plugin.show(1, any, any, any)).called(1);
  });
  
  test('should throttle progress updates', () async {
    await service.showProgressNotification(id: 1, title: 'T', progress: 50, subtitle: '');
    await service.showProgressNotification(id: 1, title: 'T', progress: 51, subtitle: '');
    // يجب أن يُستدعى مرة واحدة فقط (الفرق < 2%)
    verify(plugin.show(any, any, any, any)).called(1);
  });
  
  test('should show complete notification with actions', () async {
    await service.showCompleteNotification(
      id: 1, title: 'Test', filePath: '/path/to/file',
    );
    verify(plugin.show(1, contains('✅'), any, any)).called(1);
  });
});
```
