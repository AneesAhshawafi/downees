import 'dart:collection';
import '../../features/download/domain/entities/download_task.dart';

class DownloadQueue {
  final int maxConcurrent;
  final Queue<DownloadTask> _pending = Queue<DownloadTask>();
  final Set<String> _active = <String>{};

  DownloadQueue(this.maxConcurrent);

  bool get canStartNext => _active.length < maxConcurrent;

  int get pendingCount => _pending.length;
  int get activeCount => _active.length;
  List<DownloadTask> get pendingTasks => _pending.toList();
  Set<String> get activeTaskIds => Set.unmodifiable(_active);

  void enqueue(DownloadTask task) {
    // Prevent duplicate enqueue
    _pending.removeWhere((t) => t.id == task.id);
    _pending.add(task);
  }

  void markActive(String taskId) {
    _pending.removeWhere((t) => t.id == taskId);
    _active.add(taskId);
  }

  void markCompleted(String taskId) {
    _active.remove(taskId);
  }

  void removeFromQueue(String taskId) {
    _pending.removeWhere((t) => t.id == taskId);
    _active.remove(taskId);
  }

  bool isQueued(String taskId) => _pending.any((t) => t.id == taskId);
  bool isActive(String taskId) => _active.contains(taskId);

  DownloadTask? processNext() {
    if (!canStartNext || _pending.isEmpty) return null;
    return _pending.removeFirst();
  }

  void clear() {
    _pending.clear();
    _active.clear();
  }
}

