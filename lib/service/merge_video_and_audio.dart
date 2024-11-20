import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_downloader_totalxsoftware/service/notification_manager.dart';

Future<void> mergeVideoAndAudio({
  required Uri videoUrl,
  required Uri audioUrl,
  required int totalFileDuration,
  required void Function(String e) error,
  required void Function(double progress) onProgress,
  required void Function(File file) onComplete,
}) async {
  final appDir = await getApplicationDocumentsDirectory();
  final outputFilePath =
      '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

  String ffmpegCommand = '-i $videoUrl -i $audioUrl -c copy $outputFilePath';
  int? lastReportedProgress;

  await FFmpegKit.executeAsync(ffmpegCommand, (session) async {
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      onComplete(File(outputFilePath));
      NotificationManager.dismissNotification(
          NotificationManager.getNotificationID(videoUrl.toString()));
    } else {
      error("Failed to merge video and audio streams.");
    }
  }, (lo) {
    log("FFmpeg Log: ${lo.getMessage()}");
  }, (statistics) {
    final progress = //= (statistics.time * 100) ~/ totalFileDuration;
        ((statistics.getTime() * 100) ~/ totalFileDuration).clamp(0, 100);
    if (progress != lastReportedProgress) {
      lastReportedProgress = progress;
      onProgress(progress.toDouble());
    }
    NotificationManager.showProgressNotification(
      notificationID:
          NotificationManager.getNotificationID(videoUrl.toString()),
      title: 'Downloading...',
      progress: progress.toDouble(),
    );
  });
  onProgress(100);
}

// import 'dart:developer';
// import 'dart:io';

// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:youtube_downloader_totalxsoftware/service/notification_manager.dart';

// Future<void> mergeVideoAndAudio(
//     {required Uri videoUrl,
//     required Uri audioUrl,
//     required int totalFileDuration,
//     required void Function(String e) error,
//     required void Function(double progress) onProgress,
//     required void Function(bool isLoading) onLoading,
//     required void Function(File file) onComplete}) async {
//   final appDir =
//       await getTemporaryDirectory(); // Use temporary directory for iOS
//   final outputFilePath =
//       '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.mkv';

//   String ffmpegCommand = '-i $videoUrl -i $audioUrl -c copy $outputFilePath';
//   int? lastReportedProgress;
//   await FFmpegKit.executeAsync(ffmpegCommand, (session) async {
//     final returnCode = await session.getReturnCode();
//     if (ReturnCode.isSuccess(returnCode)) {
//       onComplete(File(outputFilePath));
//       NotificationManager.dismissNotification(
//           NotificationManager.getNotificationID(videoUrl.toString()) + 1);
//       NotificationManager.showNotification(
//         id: NotificationManager.getNotificationID(videoUrl.toString()),
//         title: 'Download Complete',
//         body: 'Your video has been downloaded.',
//       );
//     } else {
//       error("Failed to merge video and audio streams.");
//       NotificationManager.dismissNotification(
//           NotificationManager.getNotificationID(videoUrl.toString()) + 1);
//       NotificationManager.showNotification(
//         id: NotificationManager.getNotificationID(videoUrl.toString()),
//         title: 'Download Failed',
//         body: 'There was an error during download.',
//       );
//     }

//     // Notify that the loading is done
//     onLoading(false);
//   }, (lo) {
//     log("FFmpeg log: ${lo.getMessage()}");
//   }, (statistics) {
//     final progress =
//         ((statistics.getTime() * 100) ~/ totalFileDuration).clamp(0, 100);

//     // Update only if the progress has increased
//     if (progress != lastReportedProgress) {
//       lastReportedProgress = progress;
//       onProgress(progress.toDouble());
//     }
//     NotificationManager.showProgressNotification(
//       notificationID:
//           NotificationManager.getNotificationID(videoUrl.toString()) + 1,
//       title: 'Downloading...',
//       progress: progress.toDouble(),
//     );
//   });
// }
