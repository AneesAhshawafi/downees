// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'داونيز';

  @override
  String get pasteLink => 'الصق رابط الفيديو هنا...';

  @override
  String get paste => 'لصق';

  @override
  String get download => 'تحميل';

  @override
  String get history => 'السجل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get home => 'الرئيسية';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get downloadPath => 'مسار التحميل';

  @override
  String get quality => 'الجودة';

  @override
  String get audioOnly => 'صوت فقط';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get completed => 'مكتمل';

  @override
  String get failed => 'فشل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get share => 'مشاركة';

  @override
  String get redownload => 'إعادة تحميل';

  @override
  String linkDetected(String platform) {
    return 'تم اكتشاف رابط $platform';
  }

  @override
  String get downloadNow => 'تحميل الآن';

  @override
  String get ignore => 'تجاهل';

  @override
  String get noHistory => 'لا توجد تحميلات سابقة';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String fileSize(String size) {
    return '$size ميجابايت';
  }

  @override
  String get video => 'فيديو';

  @override
  String get preview => 'معاينة';
}
