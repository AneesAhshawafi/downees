import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/active_downloads_list.dart';
import '../widgets/download_button.dart';
import '../widgets/paste_button.dart';
import '../widgets/smart_paste_banner.dart';
import '../widgets/url_input_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with WidgetsBindingObserver {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeBloc>().add(AppResumed());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) =>
          prev.navigateToPreviewUrl != curr.navigateToPreviewUrl &&
          curr.navigateToPreviewUrl != null,
      listener: (context, state) {
        if (state.navigateToPreviewUrl != null) {
          context.push('/preview', extra: state.navigateToPreviewUrl);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n?.appTitle ?? 'Downees')),
        body: SafeArea(
          child: Column(
            children: [
              const SmartPasteBanner(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppDimensions.sm),
                      UrlInputBar(controller: _urlController),
                      const SizedBox(height: AppDimensions.md),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: PasteButton(controller: _urlController),
                          ),
                          const SizedBox(width: AppDimensions.md),
                          const Expanded(flex: 3, child: DownloadButton()),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      const ActiveDownloadsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
