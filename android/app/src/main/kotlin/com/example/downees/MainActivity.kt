package com.example.downees

import android.media.MediaExtractor
import android.media.MediaMuxer
import android.media.MediaScannerConnection
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.nio.ByteBuffer

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.downees/media_muxer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "muxVideoAndAudio" -> {
                    val videoPath = call.argument<String>("videoPath")
                    val audioPath = call.argument<String>("audioPath")
                    val outputPath = call.argument<String>("outputPath")

                    if (videoPath == null || audioPath == null || outputPath == null) {
                        result.error("INVALID_ARGS", "videoPath, audioPath, and outputPath are required", null)
                        return@setMethodCallHandler
                    }

                    try {
                        muxVideoAndAudio(videoPath, audioPath, outputPath)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("MUX_ERROR", "Failed to mux: ${e.message}", e.stackTraceToString())
                    }
                }
                "scanFile" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(
                            applicationContext,
                            arrayOf(path),
                            null,
                            null
                        )
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "path is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun muxVideoAndAudio(videoPath: String, audioPath: String, outputPath: String) {
        // Ensure output directory exists
        File(outputPath).parentFile?.mkdirs()

        // Delete existing output if present
        val outputFile = File(outputPath)
        if (outputFile.exists()) outputFile.delete()

        val videoExtractor = MediaExtractor()
        val audioExtractor = MediaExtractor()

        try {
            videoExtractor.setDataSource(videoPath)
            audioExtractor.setDataSource(audioPath)

            // Find video track
            var videoTrackIndex = -1
            for (i in 0 until videoExtractor.trackCount) {
                val format = videoExtractor.getTrackFormat(i)
                val mime = format.getString(android.media.MediaFormat.KEY_MIME)
                if (mime?.startsWith("video/") == true) {
                    videoTrackIndex = i
                    break
                }
            }

            // Find audio track
            var audioTrackIndex = -1
            for (i in 0 until audioExtractor.trackCount) {
                val format = audioExtractor.getTrackFormat(i)
                val mime = format.getString(android.media.MediaFormat.KEY_MIME)
                if (mime?.startsWith("audio/") == true) {
                    audioTrackIndex = i
                    break
                }
            }

            if (videoTrackIndex < 0) throw Exception("No video track found in $videoPath")
            if (audioTrackIndex < 0) throw Exception("No audio track found in $audioPath")

            videoExtractor.selectTrack(videoTrackIndex)
            audioExtractor.selectTrack(audioTrackIndex)

            val videoFormat = videoExtractor.getTrackFormat(videoTrackIndex)
            val audioFormat = audioExtractor.getTrackFormat(audioTrackIndex)

            val muxer = MediaMuxer(outputPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)

            val muxerVideoTrack = muxer.addTrack(videoFormat)
            val muxerAudioTrack = muxer.addTrack(audioFormat)

            muxer.start()

            val bufferSize = 1024 * 1024 // 1MB buffer
            val buffer = ByteBuffer.allocate(bufferSize)
            val bufferInfo = android.media.MediaCodec.BufferInfo()

            // Write video samples
            while (true) {
                val sampleSize = videoExtractor.readSampleData(buffer, 0)
                if (sampleSize < 0) break

                bufferInfo.presentationTimeUs = videoExtractor.sampleTime
                bufferInfo.size = sampleSize
                bufferInfo.flags = videoExtractor.sampleFlags
                bufferInfo.offset = 0

                muxer.writeSampleData(muxerVideoTrack, buffer, bufferInfo)
                videoExtractor.advance()
            }

            // Write audio samples
            while (true) {
                val sampleSize = audioExtractor.readSampleData(buffer, 0)
                if (sampleSize < 0) break

                bufferInfo.presentationTimeUs = audioExtractor.sampleTime
                bufferInfo.size = sampleSize
                bufferInfo.flags = audioExtractor.sampleFlags
                bufferInfo.offset = 0

                muxer.writeSampleData(muxerAudioTrack, buffer, bufferInfo)
                audioExtractor.advance()
            }

            muxer.stop()
            muxer.release()

        } finally {
            videoExtractor.release()
            audioExtractor.release()
        }

        // Scan the output file so it shows in the media library
        MediaScannerConnection.scanFile(
            applicationContext,
            arrayOf(outputPath),
            arrayOf("video/mp4"),
            null
        )
    }
}
