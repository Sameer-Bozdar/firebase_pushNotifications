import 'dart:convert';

import 'package:firebasetest/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    notificationService.getDeviceToken();
    // notificationService.isTokenRefresh;

    notificationService.getDeviceToken();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My App in Amazon")),
      body: Center(
        child: TextButton(
          onPressed: () {
            notificationService.getDeviceToken().then((value) async {
              var data = {
                "to": value.toString(),
                "priority": "high",
                "notification": {"title": "Sameer", "body": "I am Developer"},
                "data": {"type": "msj", "id": "1234"}
              };
              await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
                  body: jsonEncode(data), headers: {
                    "Content-Type" : "application/json; charset=UTF-8", 
                    "Authorization" : "key=AAAA3gqH3y0:APA91bG_fRXxoIots_Vwy5UhfcK-Re98sTrKy3KKdt7m4KX2NPGGFNw4ItacdrKDGEvxKME7-XHPjwzQxDPhbCBfCP8O50b-ReKu2dtfLZBZG2wL-Q4zUmlG2Kf_d7Obu2-IvOhqkgd3"
                  });
            });
          },
          child: Text("Get Notifications"),
        ),
      ),
    );
  }
}
