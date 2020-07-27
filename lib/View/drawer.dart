

import 'dart:convert';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/View/home_view.dart';
import 'package:fiepapp/View/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_view.dart';

Widget drawerMenu(BuildContext context) {
  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
      if(snapshot.hasData){
        String _imageUrl;
        String user = snapshot.data.getString("USER");
        Map<String, dynamic> map = jsonDecode(user);
        AccountDTO dto = AccountDTO.fromJson(map['account']);
        Widget list = listItem(dto, context);
        print(dto.toString());
        if(dto.imageUrl != null) {
          _imageUrl = dto.imageUrl;
        }
        else _imageUrl = "https://firebasestorage.googleapis.com/v0/b/fiep-e6602.appspot.com/o/users%2Fphoto-1-1590058860284452690018.jpg?alt=media&token=84430471-8893-4d2e-b233-638f702538a8";
        return Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 210,
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
                              image: NetworkImage(_imageUrl),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(dto.name,
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(dto.mail,
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.1,
                    0.4,
                    0.6,
                    0.9
                  ],
                  colors: [
                    Colors.yellow,
                    Colors.red,
                    Colors.indigo,
                    Colors.teal
                  ]
              )
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
            'Home', Icons.home, (){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()),
          );
        }),
        itemDrawer(
            'Profile', Icons.edit, (){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(dto)),
          );
        }),


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
