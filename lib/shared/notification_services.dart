import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Android initialization
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // should mention the app icon
    // during initialization itself

    // Ios initialization
    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  var notificationDetails = const NotificationDetails(
    // Android details
    android: AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: "ashwin",
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: true,
      color: Colors.black,
      colorized: true,
      visibility: NotificationVisibility.public,
      enableLights: true,
      enableVibration: true,
    ),
    // iOS details
    iOS: IOSNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> scheduleNotifications(
      {required int id,
      required String title,
      required String body,
      required String timeOfNotification}) async {
    if (DateTime.now().isBefore(
        tz.TZDateTime.from(DateTime.parse(timeOfNotification), tz.local))) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(DateTime.parse(timeOfNotification), tz.local),
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } else {
      // print('The Time of Notification $id is gone');
    }
  }
}
