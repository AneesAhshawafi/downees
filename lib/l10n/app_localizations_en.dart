// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Downees';

  @override
  String get pasteLink => 'Paste video link here...';

  @override
  String get paste => 'Paste';

  @override
  String get download => 'Download';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get downloadPath => 'Download Path';

  @override
  String get quality => 'Quality';

  @override
  String get audioOnly => 'Audio Only';

  @override
  String get downloading => 'Downloading...';

  @override
  String get completed => 'Completed';

  @override
  String get failed => 'Failed';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get redownload => 'Re-download';

  @override
  String linkDetected(String platform) {
    return '$platform link detected';
  }

  @override
  String get downloadNow => 'Download Now';

  @override
  String get ignore => 'Ignore';

  @override
  String get noHistory => 'No download history';

  @override
  String get clearHistory => 'Clear History';

  @override
  String fileSize(String size) {
    return '$size MB';
  }

  @override
  String get video => 'Video';

  @override
  String get preview => 'Preview';
}
