import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_strings.dart';

class LocaleCubit extends Cubit<Locale> {
  final Box _settingsBox;

  LocaleCubit(this._settingsBox) : super(_loadLocale(_settingsBox));

  static Locale _loadLocale(Box box) {
    final languageCode = box.get(AppStrings.keyLocale, defaultValue: 'ar');
    return Locale(languageCode);
  }

  void setLocale(Locale locale) {
    _settingsBox.put(AppStrings.keyLocale, locale.languageCode);
    emit(locale);
  }

  void toggleLocale() {
    if (state.languageCode == 'ar') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('ar'));
    }
  }
}

