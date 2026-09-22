import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_strings.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box _settingsBox;

  ThemeCubit(this._settingsBox) : super(_loadTheme(_settingsBox));

  static ThemeMode _loadTheme(Box box) {
    final value = box.get(AppStrings.keyThemeMode, defaultValue: 'system');
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void setTheme(ThemeMode mode) {
    _settingsBox.put(AppStrings.keyThemeMode, mode.name);
    emit(mode);
  }
}

