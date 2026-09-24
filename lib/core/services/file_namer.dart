import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../enums/platform_type.dart';

class FileNamer {
  /// إنشاء اسم ملف آمن من عنوان الفيديو
  static String generateFileName({
    required String title,
    required String quality,
    required String format,
    required PlatformType platform,
  }) {
    // تنظيف العنوان من الأحرف غير المسموحة واستبدالها بمسافة
    final cleanTitle = title
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // اقتصار الطول على 80 حرف
    final shortTitle = cleanTitle.length > 80
        ? cleanTitle.substring(0, 80).trim()
        : cleanTitle;

    return '${shortTitle}_${quality}_${platform.name}.$format';
  }

  static bool _canWriteToDir(String path) {
    try {
      final dir = Directory(path);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      final testFile = File(
        '${dir.path}/.test_${DateTime.now().millisecondsSinceEpoch}',
      );
      testFile.writeAsStringSync('ok');
      testFile.deleteSync();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// الحصول على مسار الحفظ الكامل والتأكد من عدم تكرار الاسم
  static Future<String> getFullSavePath({
    required String fileName,
    String? customDir,
  }) async {
    String dir = customDir ?? await getDefaultDownloadDir();
    String normalizedDir = dir.replaceAll(r'\', '/');
    String targetPath = normalizedDir.endsWith('/Downees')
        ? normalizedDir
        : '$normalizedDir/Downees';

    Directory downloadsDir = Directory(targetPath);
    try {
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }
    } catch (_) {
      try {
        final fallback = await getApplicationDocumentsDirectory();
        targetPath = '${fallback.path}/Downees';
        downloadsDir = Directory(targetPath);
        if (!downloadsDir.existsSync()) {
          downloadsDir.createSync(recursive: true);
        }
      } catch (_) {}
    }

    final safeBaseName = fileName.split(RegExp(r'[/\\]')).last;
    var filePath = '${downloadsDir.path}/$safeBaseName';
    var counter = 1;

    while (File(filePath).existsSync()) {
      final lastDot = safeBaseName.lastIndexOf('.');
      final ext = lastDot != -1 ? safeBaseName.substring(lastDot + 1) : '';
      final name = lastDot != -1
          ? safeBaseName.substring(0, lastDot)
          : safeBaseName;
      filePath = ext.isNotEmpty
          ? '${downloadsDir.path}/${name}_($counter).$ext'
          : '${downloadsDir.path}/${name}_($counter)';
      counter++;
    }

    return filePath;
  }

  /// مجلد التحميل الافتراضي بحسب نظام التشغيل
  static Future<String> getDefaultDownloadDir() async {
    try {
      if (Platform.isAndroid) {
        // 1. أولاً: فحص إمكانية الكتابة في مجلد التنزيلات العام المشترك للجهاز (المجلد الافتراضي لمدير الملفات)
        const publicPath = '/storage/emulated/0/Download';
        if (_canWriteToDir('$publicPath/Downees')) {
          return publicPath;
        }

        // 2. ثانياً: مجلد التحميلات المخصص للتطبيق في الذاكرة الخارجية
        try {
          final extDirs = await getExternalStorageDirectories(
            type: StorageDirectory.downloads,
          );
          if (extDirs != null &&
              extDirs.isNotEmpty &&
              _canWriteToDir(extDirs.first.path)) {
            return extDirs.first.path;
          }
        } catch (_) {}

        // 3. ثالثاً: مجلد التطبيق الرئيسي في الذاكرة الخارجية
        try {
          final extDir = await getExternalStorageDirectory();
          if (extDir != null && _canWriteToDir(extDir.path)) {
            return extDir.path;
          }
        } catch (_) {}

        // 4. رابعاً: استخدام مجلد مستندات التطبيق الآمن
        final appDocs = await getApplicationDocumentsDirectory();
        return appDocs.path;
      }

      final downloads = await getDownloadsDirectory();
      if (downloads != null && _canWriteToDir(downloads.path)) {
        return downloads.path;
      }

      final appDocs = await getApplicationDocumentsDirectory();
      return appDocs.path;
    } catch (_) {
      try {
        final appDocs = await getApplicationDocumentsDirectory();
        return appDocs.path;
      } catch (_) {
        return Directory.current.path;
      }
    }
  }
}
