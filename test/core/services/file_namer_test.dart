import 'dart:io';
import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/services/file_namer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileNamer', () {
    test('should sanitize file name', () {
      expect(
        FileNamer.generateFileName(
          title: 'Video: Test/File?',
          quality: '720p',
          format: 'mp4',
          platform: PlatformType.youtube,
        ),
        'Video Test File_720p_youtube.mp4',
      );
    });

    test('should truncate long title to 80 chars', () {
      final longTitle = 'A' * 120;
      final fileName = FileNamer.generateFileName(
        title: longTitle,
        quality: '1080p',
        format: 'mp4',
        platform: PlatformType.facebook,
      );

      final basePart = fileName.split('_1080p_facebook.mp4').first;
      expect(basePart.length, 80);
      expect(fileName, '${'A' * 80}_1080p_facebook.mp4');
    });

    test('should handle duplicate file names', () async {
      final tempDir = Directory.systemTemp.createTempSync('downees_file_namer_');
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final firstPath = await FileNamer.getFullSavePath(
        fileName: 'test_video.mp4',
        customDir: tempDir.path,
      );
      expect(firstPath.endsWith('test_video.mp4'), isTrue);

      // Create the file so it exists
      File(firstPath).writeAsStringSync('dummy content');

      // Next path should have _(1)
      final secondPath = await FileNamer.getFullSavePath(
        fileName: 'test_video.mp4',
        customDir: tempDir.path,
      );
      expect(secondPath.endsWith('test_video_(1).mp4'), isTrue);

      // Create second file
      File(secondPath).writeAsStringSync('dummy content 2');

      // Third path should have _(2)
      final thirdPath = await FileNamer.getFullSavePath(
        fileName: 'test_video.mp4',
        customDir: tempDir.path,
      );
      expect(thirdPath.endsWith('test_video_(2).mp4'), isTrue);
    });
  });
}

