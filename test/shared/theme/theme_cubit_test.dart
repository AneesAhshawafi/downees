import 'package:downees/core/constants/app_strings.dart';
import 'package:downees/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box {}

void main() {
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
  });

  test('initial state defaults to ThemeMode.system when box is empty', () {
    when(() => mockBox.get(AppStrings.keyThemeMode, defaultValue: 'system'))
        .thenReturn('system');

    final cubit = ThemeCubit(mockBox);
    expect(cubit.state, ThemeMode.system);
  });

  test('initial state loads saved light theme from box', () {
    when(() => mockBox.get(AppStrings.keyThemeMode, defaultValue: 'system'))
        .thenReturn('light');

    final cubit = ThemeCubit(mockBox);
    expect(cubit.state, ThemeMode.light);
  });

  test('setTheme emits new theme and saves to box', () {
    when(() => mockBox.get(AppStrings.keyThemeMode, defaultValue: 'system'))
        .thenReturn('system');
    when(() => mockBox.put(AppStrings.keyThemeMode, 'dark'))
        .thenAnswer((_) async {});

    final cubit = ThemeCubit(mockBox);
    cubit.setTheme(ThemeMode.dark);

    expect(cubit.state, ThemeMode.dark);
    verify(() => mockBox.put(AppStrings.keyThemeMode, 'dark')).called(1);
  });
}

