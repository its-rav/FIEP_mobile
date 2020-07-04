import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() {
    // TODO: implement createState
    return new _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  Container myHeader(IconData icon, String text) {
    return Container(
      height: 60,
      width: 90,
      decoration: BoxDecoration(
          color: Colors.orangeAccent[500],
          borderRadius: BorderRadius.circular(30),
//          boxShadow: [
//            BoxShadow(
//              color: Colors.orangeAccent[500],
//              spreadRadius: 1,
//            )
//          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.orangeAccent[500],
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {}),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 40,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 20,
                      spreadRadius: 10,
                    )
                  ],
                  color: Colors.orangeAccent[500],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 155),
                          child: Center(
                            child: Container(
                              height: 105,
                              width: 105,
                              decoration: BoxDecoration(
                                  color: Colors.indigo[500],
                                  borderRadius: BorderRadius.circular(52.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellow,
                                      spreadRadius: 2,
                                    )
                                  ]),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                AssetImage('assets/David-Beckham.jpg'),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '@davidbeckham',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  Container(
                    child: Text(
                      'David Beckham',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        myHeader(Icons.linked_camera, "Camera"),
                        myHeader(Icons.fingerprint, "Security"),
                        myHeader(Icons.edit, "Edit profile"),
                        myHeader(Icons.settings, "Settings")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, right: 34, left: 34),
              height: MediaQuery.of(context).size.height / 2 - 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.local_phone, color: Colors.black),
                      SizedBox(width: 20,),
                      Text('0126456789',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.cake, color: Colors.black),
                      SizedBox(width: 20,),
                      Text('03/04/1999',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.list, color: Colors.black),
                      SizedBox(width: 20,),
                      Text('Software Engineering',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40))
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: RaisedButton(
                color: Colors.deepOrange,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                elevation: 16,
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {},
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            )
          ],
        ),
      ),
    );
  }
}