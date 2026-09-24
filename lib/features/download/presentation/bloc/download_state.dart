import 'package:equatable/equatable.dart';
import '../../../../core/enums/download_status.dart';
import '../../domain/entities/download_task.dart';

class DownloadState extends Equatable {
  final Map<String, DownloadTask> tasks; // id -> task

  const DownloadState({this.tasks = const {}});

  List<DownloadTask> get activeTasks => tasks.values
      .where((t) =>
          t.status == DownloadStatus.downloading ||
          t.status == DownloadStatus.paused ||
          t.status == DownloadStatus.pending)
      .toList();

  List<DownloadTask> get completedTasks => tasks.values
      .where((t) => t.status == DownloadStatus.completed)
      .toList();

  List<DownloadTask> get failedTasks =>
      tasks.values.where((t) => t.status == DownloadStatus.failed).toList();

  List<DownloadTask> get allTasks => tasks.values.toList();

  DownloadTask? getTask(String id) => tasks[id];

  DownloadState copyWith({
    Map<String, DownloadTask>? tasks,
  }) {
    return DownloadState(
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [tasks];
}

