
import 'package:fiep/FunctionCLasses/signIn.dart';
import 'package:fiep/Pages/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomeState createState() {
    // TODO: implement createState
    return new _HomeState();
  }

}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text("FIEP"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Text("Welcome"),
            new RaisedButton(
              child: Text("Sign out"),
                onPressed: (){
                  signOutGoogle();
                  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));

                }

            )
          ],
        ),
      ),


    );
  }

}