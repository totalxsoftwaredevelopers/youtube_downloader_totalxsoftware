import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationManager {
  static final Map<String, int> _downloadTasks = {};
  static int _nextNotificationID = 1000;

  static int getNotificationID(String videoUrl) {
    if (_downloadTasks.containsKey(videoUrl)) {
      return _downloadTasks[videoUrl]!;
    }
    _downloadTasks[videoUrl] = _nextNotificationID++;
    return _downloadTasks[videoUrl]!;
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> showProgressNotification({
    required int notificationID,
    required String title,
    required double progress,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationID,
        channelKey: 'download_channel',
        
        title: title,
        body: 'Progress: ${(progress * 100).toStringAsFixed(1)}%',
        progress: progress,
        notificationLayout: NotificationLayout.ProgressBar,
      ),
    );
  }

  static Future<void> dismissNotification(int notificationID) async {
    await AwesomeNotifications().dismiss(notificationID);
  }

  static void clearTask(String videoUrl) {
    _downloadTasks.remove(videoUrl);
  }
}





// class CustomNotification {
//   static Future<void> showProgressNotification({
//     required int id,
//     required double progress,
//   }) async {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'basic_channel',
//         title: 'Downloading... ${progress.toStringAsFixed(0)}%',
//         notificationLayout: NotificationLayout.ProgressBar,
//         progress: progress,
//       ),
//     );
//   }

  // static Future<void> showNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  // }) async {
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'basic_channel',
  //       title: title,
  //       body: body,
  //       notificationLayout: NotificationLayout.Default,
  //     ),
  //   );
  // }

//   static Future<void> cancel(int id) async {
//     await AwesomeNotifications().cancel(id);
//   }
// }


