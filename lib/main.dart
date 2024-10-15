import 'package:flutter/material.dart';
import 'package:local_notiifcation_plugin_demo/HomeScreen.dart';

import 'notification_service.dart';

void main() {
  runApp(const MyApp());
  NotificationService().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
