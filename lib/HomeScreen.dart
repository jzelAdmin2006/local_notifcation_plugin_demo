import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'notification_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notificationId = 1;

  @override
  void initState() {
    super.initState();
    NotificationService().initializePlatformNotifications();
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
                NotificationService().showNotification();
              },
              child: const Text("Simple Notification"),
            ),
          ),
        ],
      ),
    );
  }
}
