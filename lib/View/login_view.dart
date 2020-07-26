import 'dart:convert';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/ViewModel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_view.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel(
     model: new LoginViewModel(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/login/school.jpg"),
            fit: BoxFit.cover,
          )),
          child: new Center(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 50, top: 30),
                child: Text("FPT Internal Event Platform",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                       )),
              ),
              _welcome(),
              _signInButton(),
              _textState()
            ],
          )),
        ),
      ),
    );
  }

  Widget _textState() {
    return ScopedModelDescendant<LoginViewModel>(

          builder: (BuildContext context, Widget child, LoginViewModel model) {
            
            if(model.isLoading){
              return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(),
                  );
            }

            else if(model.text != null && model.text.isNotEmpty){
              return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(model.text,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  );
            }

              return
              Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold)),
            );
            
          });
  }

  Widget _welcome() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GradientText(
            "FPT",
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple, Colors.deepOrange, Colors.red, Colors.pink],
            ),
            style: TextStyle(
              fontFamily: "Shoescenter",
                letterSpacing: 7,
                fontSize: 200,
                fontWeight: FontWeight.bold,
                //fontStyle: FontStyle.italic
              ),
          ),
          SizedBox(
            width: 5,
          ),
          Text("IEP",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange))
        ],
      ),
    );
  }

  Widget _signInButton() {
    return ScopedModelDescendant<LoginViewModel>(
        builder: (BuildContext context, Widget child, LoginViewModel model){
          return FlatButton(
            color: Colors.white.withOpacity(0.8),
            focusColor: Colors.white.withOpacity(1.0),
            onPressed: () async {
              AccountDTO dto = await model.changeEventLogin();
              if(dto != null){
                List<int> followGroup = await model.getGroupFollowStatus(dto.userId);
                List<int> followEvent = await model.getEventFollowStatus(dto.userId);
                SharedPreferences sp = await SharedPreferences.getInstance();
                Map<String , dynamic> map ={
                  'account' : dto.toJson(),
                  'follow group' : followGroup,
                  'follow event' : followEvent
                };
                sp.setString("USER", jsonEncode(map));

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(map)), (Route<dynamic> route) => false);
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Sign in with FPT",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Image(
                    image: AssetImage("images/login/google_logo.png"),
                    height: 35.0,
                    width: 35.0,
                  ),
                ],
              ),
            ),
          );
        }

    );
  }
}
