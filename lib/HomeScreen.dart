import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int notificationId = 1;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'), iOS: DarwinInitializationSettings()))
        .then((_) => _requestPermissions());
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
          await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      setState(() {
      });
    }
  }

  Future<void> _showNotification() async {
    await flutterLocalNotificationsPlugin.show(
        notificationId++, 'Test Title', 'This is Notification demo', const NotificationDetails(android: AndroidNotificationDetails('SwitchboxNotificationChannel', 'Switchbox Notification Channel',
        channelDescription: 'Notification Channel for Switchbox',
        importance: Importance.max,
        priority: Priority.high)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                _showNotification();
              },
              child: const Text("Simple Notification"),
            ),
          ),
        ],
      ),
    );
  }
}
