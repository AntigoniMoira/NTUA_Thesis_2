import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

Future<void> _configureLocalTimeZone() async {
  const MethodChannel platform =
  MethodChannel('antmoira/med_reminder_notifications');
  tz.initializeTimeZones();
  final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void scheduleAlarm(DateTime scheduledNotificationDateTime) async {
  FlutterLocalNotificationsPlugin localNotification;

  var androidInitialize = new AndroidInitializationSettings("@mipmap/ic_launcher");
  var iOSInitialize = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      android: androidInitialize, iOS: iOSInitialize
  );
  localNotification = new FlutterLocalNotificationsPlugin();
  localNotification.initialize(initializationSettings);

  var androidDetailes = new AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: "@mipmap/ic_launcher",
    // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
    importance: Importance.high
  );

  var iosDetails = new IOSNotificationDetails();
  var generalNotificationDetails =
  new NotificationDetails(android: androidDetailes, iOS: iosDetails);
  await _configureLocalTimeZone();
  await localNotification.zonedSchedule(
      0,
      'Office',
      'Good morning! Time for office.',
      // tz.TZDateTime.now(tz.local).add(const Duration(hours: 8)),
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local,),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime);
  // await localNotification.show(0, "Notif Title", "The body of the notification", generalNotificationDetails);
  print(scheduledNotificationDateTime);
}

// tz.TZDateTime.from(
// scheduledNotificationDateTime,
// tz.local,
// ),
// generalNotificationDetails);

// tz.TZDateTime.from(scheduledNotificationDateTime,tz.local,),