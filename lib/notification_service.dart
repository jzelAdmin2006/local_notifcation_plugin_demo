import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  int notificationId = 1;

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description:
    'This channel is used for important notifications.',
    importance: Importance.max,
    showBadge: false,
  );

  Future<void> init() async {
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestFullScreenIntentPermission();
    } else if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );
    }

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: true,
      defaultPresentBadge: false
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
  }

  requestNotificationPermission() async {
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestFullScreenIntentPermission();
    } else if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );
    }
  }

  Future<void> showNotification() async {
    await _flutterLocalNotificationsPlugin.show(
        notificationId++, 'Test Title', 'This is Notification demo', const NotificationDetails(android: AndroidNotificationDetails('SwitchboxNotificationChannel', 'Switchbox Notification Channel',
        channelDescription: 'Notification Channel for Switchbox',
        importance: Importance.max,
        priority: Priority.high)));
  }
}
