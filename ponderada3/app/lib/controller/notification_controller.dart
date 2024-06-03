import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Handle the notification action
  }

  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Handle the notification creation
  }

  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Handle the notification display
  }

  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Handle the notification dismissal
  }
}