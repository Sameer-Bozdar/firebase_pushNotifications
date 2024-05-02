import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  requestNotificationPermission() async {
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
}
