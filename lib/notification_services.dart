import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasetest/messageScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitialize =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitize = DarwinInitializationSettings();

    var initializationSettings =
        InitializationSettings(iOS: iosInitize, android: androidInitialize);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }
void firebaseInit(BuildContext context) {
  FirebaseMessaging.onMessage.listen((message) {
    print(message.notification!.title.toString());
    print(message.notification!.body.toString());
    print(message.data.toString());
    print(message.data["type"]);
    print(message.data["id"]);

    // Check if the app is in the foreground
    if (message.notification != null &&
        message.notification!.title != null &&
        message.notification!.body != null &&
        message.data["type"] != null &&
        message.data["id"] != null &&
        WidgetsBinding.instance!.lifecycleState == AppLifecycleState.resumed) {
      // App is in the foreground, handle the message as required
      handleMessage(context, message);
    } else {
      // App is in the background or terminated, show notification
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    }
  });
}

  // void firebaseInit(BuildContext context) {
  //   FirebaseMessaging.onMessage.listen((message) {
  //     print(message.notification!.title.toString());
  //     print(message.notification!.body.toString());
  //     print(message.data.toString());
  //     print(message.data["type"]);
  //     print(message.data["id"]);

  //     if (Platform.isAndroid) {
  //       initLocalNotifications(context, message);
  //       showNotification(message);
  //     } else {
  //       showNotification(message);
  //     }
  //   });
  // }

  Future showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(), "High_information_channel",
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: "Your channel Description",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "ticker");

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    
    // when app is terminated
    RemoteMessage? initializeMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    
    if (initializeMessage != null) {
      
      handleMessage(context, initializeMessage);
    }

    // when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings setting = await messaging.requestPermission(
        alert: true,
        announcement: true,
        provisional: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        sound: true);

    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print("user denied permission");
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("Device token ");
    print(token);
    return token!;
  }

  void isTokenRefresh() async {
    await messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh token ");
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data["type"] == "msj") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MessageScreen()));
    }
  }
}
