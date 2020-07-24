

import 'dart:convert';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_view.dart';

Widget drawerMenu(BuildContext context) {
  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
      if(snapshot.hasData){
        String user = snapshot.data.getString("USER");
        AccountDTO dto = AccountDTO.fromJson(jsonDecode(user));
        Widget list = listItem(dto, context);
        print(dto.toString());
        return Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 230,
                child: DrawerHeader(
                  child: Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image(
                              image: NetworkImage(dto.imageUrl),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Text(dto.name,
                          style: TextStyle(fontSize: 18, color: Colors.orange)),
                    ],
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("image/background.jpg"),
                        fit: BoxFit.cover),
//              gradient: LinearGradient(
//                  colors: [Colors.deepOrange, Colors.orangeAccent]
//              )
                  ),
                ),
              ),
              list,
              FlatButton(
                color: Colors.white,
                splashColor: Colors.lightBlue,
                onPressed: () {
                  snapshot.data.remove("USER");
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LoginPage()), (Route<dynamic> route) => false);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Text("Sign out", style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        );
      }
      return Drawer(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget listItem(AccountDTO dto, BuildContext context) {
 return Column(
      children: <Widget>[
        itemDrawer(
            'Edit Profile', Icons.edit, (){
//          Navigator.pop(context);
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => AccountPage()),
//          );
        }),

        itemDrawer("Followed Groups", Icons.group_work, (){}),
        itemDrawer("Followed Events", Icons.event, (){}),

      ],
    );

}

Widget itemDrawer(String text, IconData iconData, Function function) {
  return Container(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
    decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, style: BorderStyle.solid),
        )),
    child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(iconData),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right),
              ]),
        ),
        onTap: function),
  );
}
