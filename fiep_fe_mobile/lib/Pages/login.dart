import 'dart:developer';

import 'package:fiep/Pages/home.dart';
import 'package:fiep/FunctionCLasses/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  String _email, _password;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text("FIEP"),
      ),
      body: new Form(
        key: _formKey,
        child: new Column(
          children: <Widget>[
            new TextFormField(
              decoration: new InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value.isEmpty) return "Please input email";
              },
              onSaved: (value) => _email = value,
            ),
            new TextFormField(
              decoration: new InputDecoration(labelText: "Password"),
              validator: (value) {
                if (value.isEmpty) return "Please input password";
              },
              onSaved: (value) => _password = value,
              obscureText: true,
            ),
            new RaisedButton(
              onPressed: login,
              child: Text("Login"),
            ),
            new OutlineButton(
                child: Text("Sign in with Google"),
                onPressed: () {
                  signInWithGoogle().whenComplete(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  });
                })
          ],
        ),
      ),
    );
  }

  void login() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      print(_email + " - " + _password);
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        log("Error user");
      }
    }
  }


}
