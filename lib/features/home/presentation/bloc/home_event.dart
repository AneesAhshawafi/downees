import 'package:equatable/equatable.dart';
import '../../../../core/enums/platform_type.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {}

class UrlChanged extends HomeEvent {
  final String url;
  const UrlChanged(this.url);

  @override
  List<Object?> get props => [url];
}

class PasteFromClipboard extends HomeEvent {}

class SubmitUrl extends HomeEvent {}

class SmartPasteDetected extends HomeEvent {
  final String url;
  final PlatformType platform;
  const SmartPasteDetected(this.url, this.platform);

  @override
  List<Object?> get props => [url, platform];
}

class SmartPasteDismissed extends HomeEvent {}

class AppResumed extends HomeEvent {}

