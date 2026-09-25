import 'package:hive/hive.dart';
import '../models/download_task_model.dart';

abstract class DownloadLocalDataSource {
  Future<List<DownloadTaskModel>> getAllTasks();
  Future<DownloadTaskModel?> getTask(String id);
  Future<void> saveTask(DownloadTaskModel task);
  Future<void> deleteTask(String id);
  Future<void> clearAllTasks();
}

class DownloadLocalDataSourceImpl implements DownloadLocalDataSource {
  final Box _box;

  DownloadLocalDataSourceImpl(this._box);

  @override
  Future<List<DownloadTaskModel>> getAllTasks() async {
    final tasks = <DownloadTaskModel>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value is Map) {
        tasks.add(DownloadTaskModel.fromMap(value));
      }
    }
    // Sort newest first
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  @override
  Future<DownloadTaskModel?> getTask(String id) async {
    final value = _box.get(id);
    if (value is Map) {
      return DownloadTaskModel.fromMap(value);
    }
    return null;
  }

  @override
  Future<void> saveTask(DownloadTaskModel task) async {
    await _box.put(task.id, task.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearAllTasks() async {
    await _box.clear();
  }
}

