import 'package:go_router/go_router.dart';
import 'features/download/presentation/pages/download_preview_page.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'shared/widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) => const HistoryPage(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/preview',
      name: 'download-preview',
      builder: (context, state) {
        final url = (state.extra as String?) ?? '';
        return DownloadPreviewPage(url: url);
      },
    ),
  ],
);

