import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../../shared/localization/locale_cubit.dart';
import '../../shared/theme/theme_cubit.dart';
import '../constants/app_strings.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Hive Boxes
  final settingsBox = await Hive.openBox(AppStrings.settingsBox);
  final historyBox = await Hive.openBox(AppStrings.historyBox);
  getIt.registerSingleton<Box>(settingsBox, instanceName: AppStrings.settingsBox);
  getIt.registerSingleton<Box>(historyBox, instanceName: AppStrings.historyBox);

  // Network
  getIt.registerLazySingleton<Dio>(() => createDio());

  // Cubits
  getIt.registerFactory<ThemeCubit>(
    () => ThemeCubit(getIt<Box>(instanceName: AppStrings.settingsBox)),
  );
  getIt.registerFactory<LocaleCubit>(
    () => LocaleCubit(getIt<Box>(instanceName: AppStrings.settingsBox)),
  );
}

