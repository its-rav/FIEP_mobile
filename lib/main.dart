import 'file:///D:/SWD-Project/FIEP%2520Android%2520App/lib/ViewModel/colorConvert.dart';
import 'package:fiepapp/View/home.dart';
import 'package:flutter/material.dart';

import 'View/login.dart';
import 'View/searchResult.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "FIEP",
            theme: ThemeData(
              primarySwatch: Colors.orange,
              primaryColor: convertColor("#ffb74d"),
              primaryColorLight: convertColor("#ffe97d"),
              primaryColorDark: convertColor("#c88719"),
              secondaryHeaderColor: convertColor("#ffe082"),
              textSelectionColor: convertColor("#000000"),
            ),
            home: HomePage(),
            routes: <String, WidgetBuilder>{
              '/searchResult': (BuildContext context) => new SearchResultPage()
            },
          );


     }
}

