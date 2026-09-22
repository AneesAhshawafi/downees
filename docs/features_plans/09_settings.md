# ⚙️ Feature 09: صفحة الإعدادات

> صفحة الإعدادات تتيح للمستخدم التحكم في تجربة التطبيق: المظهر (داكن/فاتح)، اللغة، مسار التحميل، الجودة الافتراضية، وغيرها من التفضيلات.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🟡 متوسطة |
| **التبعيات** | Feature 01 (إعداد المشروع) |
| **المدة المتوقعة** | 2-3 أيام |
| **التعقيد** | منخفض - متوسط |

---

## 🎯 الأهداف

1. تبديل المظهر (داكن / فاتح / تلقائي)
2. تغيير اللغة (عربي / إنجليزي)
3. تغيير مسار التحميل الافتراضي
4. الجودة الافتراضية
5. عدد التحميلات المتزامنة
6. تفعيل/تعطيل اللصق الذكي
7. قسم "حول التطبيق"
8. حفظ جميع الإعدادات محلياً في Hive

---

## 🖼️ تصور الواجهة

```
╔══════════════════════════════════════╗
║  ⚙️ الإعدادات                         ║
╠══════════════════════════════════════╣
║                                      ║
║  ═══ المظهر ══════════════════════  ║
║                                      ║
║  🌙 الوضع الداكن                      ║
║  [تلقائي] [فاتح] [داكن]              ║
║                                      ║
║  ═══ اللغة ═══════════════════════  ║
║                                      ║
║  🌐 اللغة                        [عربي] ║
║                                      ║
║  ═══ التحميل ═════════════════════  ║
║                                      ║
║  📁 مسار التحميل     [Downloads/Downees] ║
║  🎬 الجودة الافتراضية           [720p] ║
║  🔢 التحميلات المتزامنة            [3] ║
║  📋 اللصق الذكي                   [✅ ON] ║
║  🔔 إشعارات التحميل             [✅ ON] ║
║  📶 تحميل عبر WiFi فقط          [OFF] ║
║                                      ║
║  ═══ حول التطبيق ══════════════════  ║
║                                      ║
║  📦 الإصدار                       v0.1.0 ║
║  👨💻 المطور                     [Link] ║
║  ⭐ تقييم التطبيق              [Link] ║
║  📄 سياسة الخصوصية            [Link] ║
║                                      ║
╠══════════════════════════════════════╣
║  🏠 الرئيسية │ 📂 السجل │ ⚙️ إعدادات ║
╚══════════════════════════════════════╝
```

---

## 📄 الملفات المطلوبة

```
lib/features/settings/
├── data/
│   ├── models/
│   │   └── app_settings_model.dart        # Hive Model
│   └── repositories/
│       └── settings_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── app_settings.dart              # Entity
│   ├── repositories/
│   │   └── settings_repository.dart       # Abstract
│   └── usecases/
│       ├── get_settings.dart
│       └── update_settings.dart
└── presentation/
    ├── pages/
    │   └── settings_page.dart
    ├── widgets/
    │   ├── theme_selector.dart             # اختيار المظهر
    │   ├── language_selector.dart           # اختيار اللغة
    │   ├── download_path_picker.dart       # اختيار مسار التحميل
    │   ├── quality_default_picker.dart     # الجودة الافتراضية
    │   ├── concurrent_downloads_slider.dart # عدد التحميلات المتزامنة
    │   └── about_section.dart              # حول التطبيق
    └── cubit/
        ├── settings_cubit.dart
        └── settings_state.dart
```

---

## 📄 التنفيذ التفصيلي

### 1. كيان الإعدادات

```dart
class AppSettings {
  final ThemeMode themeMode;          // system, light, dark
  final Locale locale;                // ar, en
  final String downloadPath;          // مسار التحميل
  final String defaultQuality;        // 360p, 720p, 1080p, best
  final int maxConcurrentDownloads;   // 1-5
  final bool smartPasteEnabled;       // تفعيل اللصق الذكي
  final bool notificationsEnabled;    // تفعيل الإشعارات
  final bool wifiOnlyDownload;        // تحميل WiFi فقط
  
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('ar'),
    this.downloadPath = '',
    this.defaultQuality = '720p',
    this.maxConcurrentDownloads = 3,
    this.smartPasteEnabled = true,
    this.notificationsEnabled = true,
    this.wifiOnlyDownload = false,
  });
  
  AppSettings copyWith({...});
}
```

### 2. Settings Cubit

```dart
class SettingsCubit extends Cubit<AppSettings> {
  final SettingsRepository _repository;
  
  SettingsCubit(this._repository) : super(const AppSettings()) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    emit(settings);
  }
  
  Future<void> setTheme(ThemeMode mode) async {
    final updated = state.copyWith(themeMode: mode);
    await _repository.saveSettings(updated);
    emit(updated);
  }
  
  Future<void> setLocale(Locale locale) async {
    final updated = state.copyWith(locale: locale);
    await _repository.saveSettings(updated);
    emit(updated);
  }
  
  Future<void> setDownloadPath(String path) async {
    final updated = state.copyWith(downloadPath: path);
    await _repository.saveSettings(updated);
    emit(updated);
  }
  
  Future<void> setDefaultQuality(String quality) async {
    final updated = state.copyWith(defaultQuality: quality);
    await _repository.saveSettings(updated);
    emit(updated);
  }
  
  Future<void> setMaxConcurrentDownloads(int count) async {
    final updated = state.copyWith(maxConcurrentDownloads: count.clamp(1, 5));
    await _repository.saveSettings(updated);
    emit(updated);
  }
  
  Future<void> toggleSmartPaste() async {
    final updated = state.copyWith(smartPasteEnabled: !state.smartPasteEnabled);
    await _repository.saveSettings(updated);
    emit(updated);
  }
  
  Future<void> toggleNotifications() async {
    final updated = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
    await _repository.saveSettings(updated);
    emit(updated);
  }
  
  Future<void> toggleWifiOnly() async {
    final updated = state.copyWith(wifiOnlyDownload: !state.wifiOnlyDownload);
    await _repository.saveSettings(updated);
    emit(updated);
  }
}
```

### 3. صفحة الإعدادات

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.settings)),
          body: ListView(
            children: [
              // ═══ قسم المظهر ═══
              _SectionHeader(title: 'المظهر'),
              ThemeSelector(
                currentMode: settings.themeMode,
                onChanged: (mode) => context
                  .read<SettingsCubit>()
                  .setTheme(mode),
              ),
              
              // ═══ قسم اللغة ═══
              _SectionHeader(title: 'اللغة'),
              LanguageSelector(
                currentLocale: settings.locale,
                onChanged: (locale) => context
                  .read<SettingsCubit>()
                  .setLocale(locale),
              ),
              
              // ═══ قسم التحميل ═══
              _SectionHeader(title: 'التحميل'),
              DownloadPathPicker(
                currentPath: settings.downloadPath,
                onChanged: (path) => context
                  .read<SettingsCubit>()
                  .setDownloadPath(path),
              ),
              QualityDefaultPicker(
                currentQuality: settings.defaultQuality,
                onChanged: (q) => context
                  .read<SettingsCubit>()
                  .setDefaultQuality(q),
              ),
              ConcurrentDownloadsSlider(
                value: settings.maxConcurrentDownloads,
                onChanged: (count) => context
                  .read<SettingsCubit>()
                  .setMaxConcurrentDownloads(count),
              ),
              SwitchListTile(
                title: Text('📋 اللصق الذكي'),
                subtitle: const Text('اكتشاف الروابط تلقائياً من الحافظة'),
                value: settings.smartPasteEnabled,
                onChanged: (_) => context
                  .read<SettingsCubit>()
                  .toggleSmartPaste(),
              ),
              SwitchListTile(
                title: Text('🔔 إشعارات التحميل'),
                subtitle: const Text('إشعار عند اكتمال أو فشل التحميل'),
                value: settings.notificationsEnabled,
                onChanged: (_) => context
                  .read<SettingsCubit>()
                  .toggleNotifications(),
              ),
              SwitchListTile(
                title: Text('📶 WiFi فقط'),
                subtitle: const Text('التحميل فقط عند الاتصال بـ WiFi'),
                value: settings.wifiOnlyDownload,
                onChanged: (_) => context
                  .read<SettingsCubit>()
                  .toggleWifiOnly(),
              ),
              
              // ═══ قسم حول التطبيق ═══
              _SectionHeader(title: 'حول التطبيق'),
              const AboutSection(),
            ],
          ),
        );
      },
    );
  }
}
```

### 4. اختيار المظهر

```dart
class ThemeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(
            value: ThemeMode.system,
            icon: Icon(Icons.brightness_auto),
            label: Text('تلقائي'),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(Icons.light_mode),
            label: Text('فاتح'),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(Icons.dark_mode),
            label: Text('داكن'),
          ),
        ],
        selected: {currentMode},
        onSelectionChanged: (modes) => onChanged(modes.first),
      ),
    );
  }
}
```

### 5. اختيار اللغة

```dart
class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onChanged;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Text('🌐', style: TextStyle(fontSize: 24)),
      title: const Text('اللغة'),
      trailing: DropdownButton<Locale>(
        value: currentLocale,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(
            value: Locale('ar'),
            child: Text('العربية'),
          ),
          DropdownMenuItem(
            value: Locale('en'),
            child: Text('English'),
          ),
        ],
        onChanged: (locale) {
          if (locale != null) onChanged(locale);
        },
      ),
    );
  }
}
```

---

## ✅ معايير القبول

- [ ] تغيير المظهر (تلقائي/فاتح/داكن) يعمل فوراً
- [ ] تغيير اللغة يعمل فوراً مع تغيير اتجاه الواجهة (RTL/LTR)
- [ ] تغيير مسار التحميل يفتح منتقي المجلدات
- [ ] الجودة الافتراضية تُطبق على التحميلات الجديدة
- [ ] عدد التحميلات المتزامنة يؤثر على محرك التحميل
- [ ] تعطيل اللصق الذكي يمنع البانر من الظهور
- [ ] جميع الإعدادات محفوظة وتبقى بعد إغلاق التطبيق
- [ ] قسم "حول التطبيق" يعرض الإصدار والروابط

---

## 🧪 خطة الاختبار

```dart
group('SettingsCubit', () {
  test('should load settings from repository', () {
    final cubit = SettingsCubit(mockRepo);
    expect(cubit.state.themeMode, ThemeMode.system);
  });
  
  test('should change theme and save', () {
    cubit.setTheme(ThemeMode.dark);
    expect(cubit.state.themeMode, ThemeMode.dark);
    verify(mockRepo.saveSettings(any)).called(1);
  });
  
  test('should change locale and save', () {
    cubit.setLocale(const Locale('en'));
    expect(cubit.state.locale, const Locale('en'));
  });
  
  test('should clamp concurrent downloads to 1-5', () {
    cubit.setMaxConcurrentDownloads(10);
    expect(cubit.state.maxConcurrentDownloads, 5);
    
    cubit.setMaxConcurrentDownloads(0);
    expect(cubit.state.maxConcurrentDownloads, 1);
  });
});
```
