import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d show log;
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  int notificationId = 1;
  static final NotificationService _notificationService =
  NotificationService._internal();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final StreamController<ReceivedNotification>
  didReceiveLocalNotificationStream =
  StreamController<ReceivedNotification>.broadcast();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    showBadge: false,
  );

  Future<void> init() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestFullScreenIntentPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> registerNotification() async {

    // firebaseMessaging.onTokenRefresh.listen((value) async {
    //   Get.log('VALUE--$value');
    //   final installation = await ParseInstallation.currentInstallation();
    //   installation.deviceToken = value;
    //   await installation.save();
    // });


      // updateParseInstallation(value);

      // final installation = await ParseInstallation.currentInstallation();
      // installation.deviceToken = value;
      // await installation.save();

      // d.log('NOTIFICATION SERVICE : : ${installation.deviceToken}');
      // d.log('NOTIFICATION SERVICE : : ${installation.objectId}');

      // GetStorage().write('NOTIFICATION', value);
      // GetStorage().write('userId', installation.objectId.toString());
  }

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: true,
      defaultPresentBadge: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  ///2
  Future<void> setupInteractedMessage() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
        requestBadgePermission: false, defaultPresentBadge: false);
    const initSettings = InitializationSettings(android: android, iOS: iOS);

    //
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Get any messages which caused the application to open from
    // a terminated state.

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

      // AndroidNotification? android = message.notification!.android;

        // showErrorSnackBar('message');

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.


        flutterLocalNotificationsPlugin.show(
          notificationId++,
          "test asdf",
          "test qwert",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              channelShowBadge: false,
            ),
          ),
        );
      }

  requestNotificationPermission() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestFullScreenIntentPermission()
          .then((permissionGranted) {
        if (permissionGranted!) {
          log("Permission Granted");
        } else {
          log("Permission Denied");
        }
      });
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      )
          .then((permissionGranted) {
        if (permissionGranted!) {
          log("Permission Granted");
        } else {
          log("Permission Denied");
        }
      });
    }
  }
  }


void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
    ) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
  // Get.to(const HelloAppScreen());
}

notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }

  // Get.to(const HelloAppScreen());
}

// Future updateParseInstallation(token) async {
//   Get.log("updateParseInstallationt $token");
//   var installation = await ParseInstallation.currentInstallation();
//   installation.set("deviceToken", token);
//   var apiResponse = await installation.save();
//   if (apiResponse.success) {
//     Get.log("updateParseInstallationt updated ${apiResponse.result}");
//   }
// }

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}


// {number: 3478714353, alert: Switchbox sync is complete., type: OUT, OUTLET2: 1, OUTLET1: 1}