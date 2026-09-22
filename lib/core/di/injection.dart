import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../features/download/data/datasources/video_api_datasource.dart';
import '../../features/download/data/datasources/youtube_datasource.dart';
import '../../features/download/data/repositories/video_repository_impl.dart';
import '../../features/download/domain/repositories/video_repository.dart';
import '../../features/download/domain/usecases/fetch_video_info.dart';
import '../../features/download/presentation/bloc/preview_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../shared/localization/locale_cubit.dart';
import '../../shared/theme/theme_cubit.dart';
import '../constants/app_strings.dart';
import '../network/api_client.dart';
import '../utils/clipboard_watcher.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Hive Boxes
  final settingsBox = await Hive.openBox(AppStrings.settingsBox);
  final historyBox = await Hive.openBox(AppStrings.historyBox);
  getIt.registerSingleton<Box>(
    settingsBox,
    instanceName: AppStrings.settingsBox,
  );
  getIt.registerSingleton<Box>(historyBox, instanceName: AppStrings.historyBox);

  // Network
  getIt.registerLazySingleton<Dio>(() => createDio());

  // Services & Data Sources
  getIt.registerLazySingleton<ClipboardWatcher>(() => ClipboardWatcher());
  getIt.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<YoutubeRemoteDataSource>(
    () => YoutubeRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(
      remoteDataSource: getIt<VideoRemoteDataSource>(),
      youtubeDataSource: getIt<YoutubeRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<FetchVideoInfo>(
    () => FetchVideoInfo(getIt<VideoRepository>()),
  );

  // Cubits & Blocs
  getIt.registerFactory<ThemeCubit>(
    () => ThemeCubit(getIt<Box>(instanceName: AppStrings.settingsBox)),
  );
  getIt.registerFactory<LocaleCubit>(
    () => LocaleCubit(getIt<Box>(instanceName: AppStrings.settingsBox)),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(clipboardWatcher: getIt<ClipboardWatcher>()),
  );
  getIt.registerFactory<PreviewBloc>(
    () => PreviewBloc(fetchVideoInfo: getIt<FetchVideoInfo>()),
  );
}
