import 'package:downees/core/constants/app_strings.dart';
import 'package:downees/shared/localization/locale_cubit.dart';
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

  test('initial state defaults to Arabic (ar) when box is empty', () {
    when(() => mockBox.get(AppStrings.keyLocale, defaultValue: 'ar'))
        .thenReturn('ar');

    final cubit = LocaleCubit(mockBox);
    expect(cubit.state, const Locale('ar'));
  });

  test('setLocale emits new locale and saves to box', () {
    when(() => mockBox.get(AppStrings.keyLocale, defaultValue: 'ar'))
        .thenReturn('ar');
    when(() => mockBox.put(AppStrings.keyLocale, 'en'))
        .thenAnswer((_) async {});

    final cubit = LocaleCubit(mockBox);
    cubit.setLocale(const Locale('en'));

    expect(cubit.state, const Locale('en'));
    verify(() => mockBox.put(AppStrings.keyLocale, 'en')).called(1);
  });

  test('toggleLocale switches between ar and en', () {
    when(() => mockBox.get(AppStrings.keyLocale, defaultValue: 'ar'))
        .thenReturn('ar');
    when(() => mockBox.put(AppStrings.keyLocale, any()))
        .thenAnswer((_) async {});

    final cubit = LocaleCubit(mockBox);
    cubit.toggleLocale();

    expect(cubit.state, const Locale('en'));

    cubit.toggleLocale();
    expect(cubit.state, const Locale('ar'));
  });
}

