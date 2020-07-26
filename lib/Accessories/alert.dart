import 'package:flutter/material.dart';

Future<int> getOption(BuildContext context, String text) async {
  int option;
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  splashColor: Colors.blue,
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    option = 1;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  splashColor: Colors.blue,
                  child: Text("No", style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    option = 0;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ]),
        );
      });
  return option;
}

void alertNoti(BuildContext context, String text, Widget item) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(text),
            content: Container(
              width: 50,
              height: 50,
              child: Center(
                child: item,
              ),
            ));
      });
}