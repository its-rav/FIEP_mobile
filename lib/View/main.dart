import 'dart:convert';
import 'dart:io';

import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/FunctionCLasses/colorConvert.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Services/push_notification_service.dart';
import 'package:fiepapp/View/home_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_view.dart';




void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
      home: checkAuthorize(),
    );
  }

  Widget checkAuthorize() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context,
          AsyncSnapshot<SharedPreferences> snapshot) {
        PushNotificationService ps = new PushNotificationService();
        ps.init(navigatorKey.currentState.overlay.context);
        if (snapshot.hasData) {
          String user = snapshot.data.getString("USER");
          if (user != null) {
            AccountDTO dto = AccountDTO.fromJson(jsonDecode(user));
            return HomePage(dto);
          }
        }
        return LoginPage();
      },
    );
  }

}