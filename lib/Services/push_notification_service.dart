import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _initialized = false;

  Future<String> init() async {
    if (!_initialized) {
      if (Platform.isIOS) {
        _fcm.requestNotificationPermissions(IosNotificationSettings());
      } else {
        _fcm.requestNotificationPermissions();
      }
      _fcm.configure(
        //Called when the app is in the foreground and we receive a push notification
        onMessage: (Map<String, dynamic> message) async {
          print('onMessage: $message');
        },
        //Called when the app has been closed completely and its opened
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
        },
        //Called when the app is in the background
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },
      );
      String token = await _fcm.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
      return token;
    }
  }
}
