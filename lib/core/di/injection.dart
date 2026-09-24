import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../features/download/data/datasources/download_local_datasource.dart';
import '../../features/download/data/datasources/video_api_datasource.dart';
import '../../features/download/data/datasources/youtube_datasource.dart';
import '../../features/download/data/repositories/download_repository_impl.dart';
import '../../features/download/data/repositories/video_repository_impl.dart';
import '../../features/download/domain/repositories/download_repository.dart';
import '../../features/download/domain/repositories/video_repository.dart';
import '../../features/download/domain/usecases/cancel_download.dart';
import '../../features/download/domain/usecases/fetch_video_info.dart';
import '../../features/download/domain/usecases/pause_download.dart';
import '../../features/download/domain/usecases/resume_download.dart';
import '../../features/download/domain/usecases/retry_download.dart';
import '../../features/download/domain/usecases/start_download.dart';
import '../../features/download/presentation/bloc/download_bloc.dart';
import '../../features/download/presentation/bloc/preview_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../shared/localization/locale_cubit.dart';
import '../../shared/theme/theme_cubit.dart';
import '../constants/app_strings.dart';
import '../network/api_client.dart';
import '../services/download_manager.dart';
import '../services/download_queue.dart';
import '../utils/clipboard_watcher.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Hive Boxes
  final settingsBox = await Hive.openBox(AppStrings.settingsBox);
  final historyBox = await Hive.openBox(AppStrings.historyBox);
  final downloadsBox = await Hive.openBox(AppStrings.downloadsBox);

  getIt.registerSingleton<Box>(
    settingsBox,
    instanceName: AppStrings.settingsBox,
  );
  getIt.registerSingleton<Box>(historyBox, instanceName: AppStrings.historyBox);
  getIt.registerSingleton<Box>(
    downloadsBox,
    instanceName: AppStrings.downloadsBox,
  );

  // Network
  getIt.registerLazySingleton<Dio>(() => createDio());

  // Services & Data Sources
  getIt.registerLazySingleton<ClipboardWatcher>(() => ClipboardWatcher());
  getIt.registerLazySingleton<DownloadQueue>(() => DownloadQueue(3));
  getIt.registerLazySingleton<DownloadManager>(
    () => DownloadManager(
      dio: createDownloadDio(),
      queue: getIt<DownloadQueue>(),
    ),
  );
  getIt.registerLazySingleton<DownloadLocalDataSource>(
    () => DownloadLocalDataSourceImpl(
      getIt<Box>(instanceName: AppStrings.downloadsBox),
    ),
  );
  getIt.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<YoutubeRemoteDataSource>(
    () => YoutubeRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<DownloadRepository>(
    () => DownloadRepositoryImpl(
      downloadManager: getIt<DownloadManager>(),
      localDataSource: getIt<DownloadLocalDataSource>(),
    ),
  );
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
  getIt.registerLazySingleton<StartDownloadUseCase>(
    () => StartDownloadUseCase(getIt<DownloadRepository>()),
  );
  getIt.registerLazySingleton<PauseDownloadUseCase>(
    () => PauseDownloadUseCase(getIt<DownloadRepository>()),
  );
  getIt.registerLazySingleton<ResumeDownloadUseCase>(
    () => ResumeDownloadUseCase(getIt<DownloadRepository>()),
  );
  getIt.registerLazySingleton<CancelDownloadUseCase>(
    () => CancelDownloadUseCase(getIt<DownloadRepository>()),
  );
  getIt.registerLazySingleton<RetryDownloadUseCase>(
    () => RetryDownloadUseCase(getIt<DownloadRepository>()),
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
  getIt.registerLazySingleton<DownloadBloc>(
    () => DownloadBloc(
      downloadRepository: getIt<DownloadRepository>(),
      startDownloadUseCase: getIt<StartDownloadUseCase>(),
      pauseDownloadUseCase: getIt<PauseDownloadUseCase>(),
      resumeDownloadUseCase: getIt<ResumeDownloadUseCase>(),
      cancelDownloadUseCase: getIt<CancelDownloadUseCase>(),
      retryDownloadUseCase: getIt<RetryDownloadUseCase>(),
    ),
  );
}
