import 'package:fiepapp/FunctionCLasses/signIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String _text = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text("FIEP"),
      ),
      body: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login/school.jpg"),
            fit: BoxFit.cover,

          )

        ),
        child: new Center(

          child: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                    Container(
                      margin: const EdgeInsets.only(bottom: 85, top: 10),
                      child: Text("FPT Internal Event Platform",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold
                          )
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.only(bottom: 200),
                      child: Row(
                        crossAxisAlignment:  CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GradientText("FPT",
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.deepOrange, Colors.pink],
                            ),
                            style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                          ),
                          Text("IEP",
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color : Colors.blueAccent)
                          )
                        ],
                      ),
                    ),

                  _signInButton(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(_text,
                        style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold)),
                  )
                ],
              ),

          ),
        ),

    );
  }

  Widget _signInButton() {
    return FlatButton(
        color: Colors.white.withOpacity(0.8),
        focusColor: Colors.white.withOpacity(1.0),
        onPressed: () async {
          signOutGoogle();
          int response = await validateAccount();

          if (response == 200) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                ModalRoute.withName('/'));
            setState(() {
              _text = "";
            });

          } else if(response == 401) {
            setState(() {
              _text = "Error. User don't have authorized!";
            });

          }
          else{
            setState(() {
              _text = "An error has occurred. Please try app later!";
            });
          }


         /* _check = 0;

          String token = await signInWithGoogle();
          if(token != null){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                ModalRoute.withName('/'));
          }

          else{
            _check = -1;
          }*/

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
                  "Sign in with Google",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
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

}