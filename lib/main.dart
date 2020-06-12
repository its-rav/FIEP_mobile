import 'package:fiepapp/FunctionCLasses/colorConvert.dart';
import 'package:flutter/material.dart';

import 'Pages/login.dart';
import 'Services/push_notification_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  PushNotificationService _pushNotificationService=PushNotificationService();
  @override
  Widget build(BuildContext context) {
    _pushNotificationService.init();
          return MaterialApp(
            title: "FIEP",
            theme: ThemeData(
              primarySwatch: Colors.orange,
              primaryColor: convertColor("#ffb74d"),
              primaryColorLight: convertColor("#ffe97d"),
              primaryColorDark: convertColor("#c88719"),
              secondaryHeaderColor: convertColor("#ffe082"),
              textSelectionColor: convertColor("#000000"),
            ),
            home: LoginPage(),
          );


     }
}

