# 🏗️ Feature 01: إعداد المشروع والبنية الأساسية

> تأسيس البنية التحتية للمشروع بما يشمل الهيكلة، إدارة الحالة، الحقن، التوجيه، النظام اللوني، ودعم اللغات.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🔴 حرجة — يجب تنفيذها أولاً |
| **التبعيات** | لا يوجد |
| **المدة المتوقعة** | 3-4 أيام |
| **التعقيد** | متوسط |

---

## 🎯 الأهداف

1. إعداد هيكلة المجلدات حسب Feature-First Architecture
2. إعداد نظام Dependency Injection باستخدام `get_it` + `injectable`
3. إعداد نظام التوجيه (Routing) باستخدام `go_router`
4. إعداد نظام إدارة الحالة (BLoC)
5. إعداد نظام الثيمات (فاتح / داكن) مع تبديل تلقائي ويدوي
6. إعداد نظام الترجمة (العربية / الإنجليزية) مع دعم RTL
7. إعداد Base Classes مشتركة

---

## 📦 الحزم المطلوبة

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  # State Management
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7
  # Dependency Injection
  get_it: ^8.0.3
  injectable: ^2.5.0
  # Navigation
  go_router: ^15.1.0
  # Storage
  hive: ^4.0.0
  hive_flutter: ^1.1.0
  # Network
  dio: ^5.8.0
  # Utils
  path_provider: ^2.1.5
  permission_handler: ^11.4.0
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  injectable_generator: ^2.7.0
  build_runner: ^2.4.15
  hive_generator: ^2.0.1
```

---

## 📁 هيكلة المجلدات المطلوبة

```
lib/
├── main.dart                    # نقطة البداية
├── app.dart                     # MaterialApp + Router + Theme + Localization
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # الألوان الأساسية
│   │   ├── app_strings.dart     # نصوص ثابتة
│   │   ├── app_dimensions.dart  # أبعاد ثابتة (padding, radius...)
│   │   └── api_constants.dart   # روابط API
│   ├── enums/
│   │   ├── platform_type.dart   # youtube, instagram, tiktok, twitter, facebook
│   │   └── download_status.dart # pending, downloading, paused, completed, failed
│   ├── utils/
│   │   ├── url_parser.dart
│   │   ├── file_utils.dart
│   │   └── permission_handler.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── api_interceptors.dart
│   │   └── api_exceptions.dart
│   ├── errors/
│   │   ├── failures.dart        # Failure classes
│   │   └── exceptions.dart      # Exception classes
│   └── di/
│       └── injection.dart
│
├── features/
│   ├── home/
│   ├── download/
│   ├── history/
│   └── settings/
│
├── shared/
│   ├── widgets/
│   │   ├── app_snackbar.dart
│   │   ├── loading_overlay.dart
│   │   └── error_widget.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── light_theme.dart
│       └── dark_theme.dart
│
└── l10n/
    ├── app_ar.arb
    └── app_en.arb
```

---

## 📄 التنفيذ التفصيلي

### 1. إعداد `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize DI
  await configureDependencies();
  
  runApp(const DowneesApp());
}
```

### 2. إعداد `app.dart`

```dart
class DowneesApp extends StatelessWidget {
  const DowneesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                title: 'Downees',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: const [
                  Locale('ar'),
                  Locale('en'),
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: appRouter,
              );
            },
          );
        },
      ),
    );
  }
}
```

### 3. نظام الثيمات

#### `app_theme.dart`
```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primary,
    fontFamily: 'Cairo', // خط عربي
    // ... تخصيصات إضافية
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: AppColors.primary,
    fontFamily: 'Cairo',
    // ... تخصيصات إضافية
  );
}
```

#### `theme_cubit.dart`
```dart
class ThemeCubit extends Cubit<ThemeMode> {
  final Box _settingsBox;
  
  ThemeCubit(this._settingsBox) 
    : super(_loadTheme(_settingsBox));
  
  static ThemeMode _loadTheme(Box box) {
    final value = box.get('themeMode', defaultValue: 'system');
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
  
  void setTheme(ThemeMode mode) {
    _settingsBox.put('themeMode', mode.name);
    emit(mode);
  }
}
```

### 4. نظام الترجمة

#### `app_ar.arb`
```json
{
  "@@locale": "ar",
  "appTitle": "داونيز",
  "pasteLink": "الصق رابط الفيديو هنا...",
  "paste": "لصق",
  "download": "تحميل",
  "history": "السجل",
  "settings": "الإعدادات",
  "home": "الرئيسية",
  "darkMode": "الوضع الداكن",
  "language": "اللغة",
  "downloadPath": "مسار التحميل",
  "quality": "الجودة",
  "audioOnly": "صوت فقط",
  "downloading": "جاري التحميل...",
  "completed": "مكتمل",
  "failed": "فشل",
  "cancel": "إلغاء",
  "delete": "حذف",
  "share": "مشاركة",
  "redownload": "إعادة تحميل",
  "linkDetected": "تم اكتشاف رابط {platform}",
  "@linkDetected": { "placeholders": { "platform": {} } },
  "downloadNow": "تحميل الآن",
  "ignore": "تجاهل",
  "noHistory": "لا توجد تحميلات سابقة",
  "clearHistory": "مسح السجل",
  "fileSize": "{size} ميجابايت",
  "@fileSize": { "placeholders": { "size": {} } }
}
```

#### `app_en.arb`
```json
{
  "@@locale": "en",
  "appTitle": "Downees",
  "pasteLink": "Paste video link here...",
  "paste": "Paste",
  "download": "Download",
  "history": "History",
  "settings": "Settings",
  "home": "Home",
  "darkMode": "Dark Mode",
  "language": "Language",
  "downloadPath": "Download Path",
  "quality": "Quality",
  "audioOnly": "Audio Only",
  "downloading": "Downloading...",
  "completed": "Completed",
  "failed": "Failed",
  "cancel": "Cancel",
  "delete": "Delete",
  "share": "Share",
  "redownload": "Re-download",
  "linkDetected": "{platform} link detected",
  "@linkDetected": { "placeholders": { "platform": {} } },
  "downloadNow": "Download Now",
  "ignore": "Ignore",
  "noHistory": "No download history",
  "clearHistory": "Clear History",
  "fileSize": "{size} MB",
  "@fileSize": { "placeholders": { "size": {} } }
}
```

### 5. نظام التوجيه

```dart
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) => const HistoryPage(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/preview',
      name: 'download-preview',
      builder: (context, state) => DownloadPreviewPage(
        url: state.extra as String,
      ),
    ),
  ],
);
```

### 6. Dependency Injection

```dart
final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Hive Boxes
  final settingsBox = await Hive.openBox('settings');
  final historyBox = await Hive.openBox('history');
  getIt.registerSingleton<Box>(settingsBox, instanceName: 'settings');
  getIt.registerSingleton<Box>(historyBox, instanceName: 'history');
  
  // Network
  getIt.registerLazySingleton<Dio>(() => createDio());
  
  // Cubits
  getIt.registerFactory<ThemeCubit>(
    () => ThemeCubit(getIt<Box>(instanceName: 'settings')),
  );
  getIt.registerFactory<LocaleCubit>(
    () => LocaleCubit(getIt<Box>(instanceName: 'settings')),
  );
}
```

### 7. Network Layer

```dart
Dio createDio() {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
    RetryInterceptor(dio: dio, retries: 3),
  ]);
  
  return dio;
}
```

### 8. Error Handling

```dart
// failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class UnsupportedPlatformFailure extends Failure {
  const UnsupportedPlatformFailure(super.message);
}

class InvalidUrlFailure extends Failure {
  const InvalidUrlFailure(super.message);
}
```

### 9. Enums

```dart
// platform_type.dart
enum PlatformType {
  youtube('YouTube', '🔴'),
  instagram('Instagram', '📸'),
  tiktok('TikTok', '🎵'),
  twitter('Twitter/X', '🐦'),
  facebook('Facebook', '🔵'),
  unknown('Unknown', '❓');

  final String displayName;
  final String emoji;
  const PlatformType(this.displayName, this.emoji);
}

// download_status.dart
enum DownloadStatus {
  pending,
  fetching,    // جلب معلومات الفيديو
  ready,       // جاهز للتحميل (معاينة)
  downloading,
  paused,
  completed,
  failed,
  cancelled;
}
```

---

## ✅ معايير القبول (Acceptance Criteria)

- [ ] المشروع يعمل بدون أخطاء بعد إضافة جميع الحزم
- [ ] `flutter run` يعمل بنجاح
- [ ] هيكلة المجلدات مطبقة بالكامل
- [ ] DI يعمل بشكل صحيح
- [ ] التنقل بين الصفحات الثلاث (الرئيسية، السجل، الإعدادات) يعمل
- [ ] الثيم الفاتح والداكن يعملان + التبديل التلقائي حسب النظام
- [ ] الترجمة للعربية والإنجليزية تعمل + RTL
- [ ] `build_runner` يعمل بدون أخطاء

---

## 🧪 خطة الاختبار

```dart
// test/core/theme_cubit_test.dart
test('should emit ThemeMode.dark when setTheme(dark) is called', () {
  final cubit = ThemeCubit(mockBox);
  cubit.setTheme(ThemeMode.dark);
  expect(cubit.state, ThemeMode.dark);
});

// test/core/locale_cubit_test.dart
test('should emit Locale(ar) when setLocale(ar) is called', () {
  final cubit = LocaleCubit(mockBox);
  cubit.setLocale(const Locale('ar'));
  expect(cubit.state, const Locale('ar'));
});
```

---

## 📎 ملاحظات

- استخدام Material 3 لواجهة حديثة
- خط **Cairo** للغة العربية (إضافته في `pubspec.yaml` تحت `fonts`)
- جميع الـ Cubits/Blocs يتم إنشاؤها عبر `get_it` للقابلية للاختبار
- استخدام `equatable` في جميع الـ States والـ Events
