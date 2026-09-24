import 'package:flutter/services.dart';

class MediaMuxerService {
  static const MethodChannel _channel =
      MethodChannel('com.example.downees/media_muxer');

  /// Muxes a video file and an audio file into a single MP4 container.
  Future<bool> muxVideoAndAudio({
    required String videoPath,
    required String audioPath,
    required String outputPath,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('muxVideoAndAudio', {
        'videoPath': videoPath,
        'audioPath': audioPath,
        'outputPath': outputPath,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('فشل دمج الصوت والفيديو: ${e.message}');
    }
  }

  /// Tells the Android MediaScanner to index the newly created file.
  Future<void> scanFile(String path) async {
    try {
      await _channel.invokeMethod<bool>('scanFile', {'path': path});
    } catch (_) {
      // Ignored if platform does not support MediaScanner (e.g. desktop/unit tests)
    }
  }
}
